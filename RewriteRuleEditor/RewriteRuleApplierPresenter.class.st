"
I am a tool that provides a UI for applying a rewrite rule on a certain scope of classes.

In my left column, you can select one or many packages. When you do that, all of their classes will be automatically added to the scope. Also, if you do not want to apply the rewrite rule to all the package's classes, you can select the specific classes on which you want the rewrite rule to be applied.

The methods column shows all the methods the rewrite rule will change. You cannot apply the rewrite rule to a specific method, only to a set of classes.
Remember that multiple selection in supported.

You can open me whit:
`RewriteRuleApplierPresenter open`
"
Class {
	#name : #RewriteRuleApplierPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'selectedClasses',
		'applyOnSelectedClassesButton',
		'applyOnAllClassesButton',
		'openLoaderButton',
		'onlyMyRulesCheckbox',
		'classesListWithFilter',
		'methodsListWithFilter',
		'packagesListWithFilter',
		'rulesDropList'
	],
	#category : #'RewriteRuleEditor-Applier'
}

{ #category : #accessing }
RewriteRuleApplierPresenter class >> descriptionText [

	^ 'Apply your custom rewrite rules to any packages or classes'
]

{ #category : #accessing }
RewriteRuleApplierPresenter class >> icon [
	^ self iconNamed: #objects
]

{ #category : #api }
RewriteRuleApplierPresenter class >> obtainChanges: classes forRule: aRule [

	| changes critiques checker env |
	env := RBClassEnvironment classes: classes.
	checker := ReSmalllintChecker new
		           rule: { aRule };
		           environment: env;
		           yourself.
	checker run.
	critiques := (checker criticsOf: aRule) asArray.
	changes := critiques collect: #change.
	^ changes
]

{ #category : #api }
RewriteRuleApplierPresenter class >> obtainChangesWithoutRB: classes forRule: aRule [

	"This is a way to obtain the same changes array as obtainChanges:forRule: method. But, here this is done without an RBClassEnvironment and ReSmalllintChecker. Because those two classes inherits from RB rules and will be eventually will be deprecated."

	"Take the methods and apply the rule on each of them (in fact on their nodes).
Take a look on ReCriticEngine for some automation ideas. Also take a look at CompiledMethod >> #critiques"

	| methods critiques changes |
	"Extract all the methods from the needed classes."
	methods := classes flatCollect: #methods.
	critiques := OrderedCollection new.
	methods
		do: [ :method | 
			| rulesCritiques |
			"We need to run the rule for each method and combine resulting critiques.
						 In fact rewrite rules check AST nodes. So, we need to run the rule for every AST node of the method and combine the results."
			rulesCritiques := method ast allChildren flatCollect: [ :node | 
				                  aRule check: node ].

			"This is a hack. Resulting critiques will tell they reffer to a single AST node. But, as the rewriting functionality requires actual method instances, we go over each critique and reassign the source entity to the method."
			rulesCritiques do: [ :critique | 
				critique sourceAnchor initializeEnitity: method ].
			critiques addAll: rulesCritiques ]
		displayingProgress: [ :method | 
		'Running critics on: ' , method methodClass name ].

	"At this point you have a collection of critiques. Each critique can tell you which rule created it, and which target it criticizes.
	As the critiques are 'smart', the type you have here (node replace critiques) can give you change compatible with the ChangesBrowser or RewriteChangesBrowser."
	changes := critiques collect: #change.
	^ changes
]

{ #category : #api }
RewriteRuleApplierPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #api }
RewriteRuleApplierPresenter class >> runReplaceOnAllClasses: aRule [

	| changes allSystemsClasses |
	allSystemsClasses := RPackage organizer packages flatCollect:
		                     #classes.
	changes := self obtainChanges: allSystemsClasses forRule: aRule.
	^ (RewriteChangesBrowser changes: changes) open
]

{ #category : #api }
RewriteRuleApplierPresenter class >> runReplaceOnAllClassesWithoutRB: aRule [

	| changes allSystemsClasses |
	allSystemsClasses := RPackage organizer packages flatCollect:
		                     #classes.
	changes := self
		           obtainChangesWithoutRB: allSystemsClasses
		           forRule: aRule.
	^ (RewriteChangesBrowser changes: changes) open
]

{ #category : #accessing }
RewriteRuleApplierPresenter class >> title [

	^ 'Rewrite Rule Applier'
]

{ #category : #actions }
RewriteRuleApplierPresenter >> classesChanged [

	selectedClasses := classesListWithFilter listPresenter selectedItems.
	self populateMethodsListWithEnvironmentClasses
]

{ #category : #private }
RewriteRuleApplierPresenter >> classesListWithFilter [

	"This accessors should only be called in the test."

	^ classesListWithFilter
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> connectPresenters [

	packagesListWithFilter listPresenter whenSelectionChangedDo: [ 
		self packagesChanged ].
	classesListWithFilter listPresenter whenSelectionChangedDo: [ 
		self classesChanged ].
	applyOnSelectedClassesButton action: [ self runReplace ].
	applyOnAllClassesButton action: [ self runReplaceOnAllClasses ].
	openLoaderButton action: [ self openLoader ].
	onlyMyRulesCheckbox whenChangedDo: [ self customRulesCheckBoxChanged ]
]

{ #category : #actions }
RewriteRuleApplierPresenter >> customRulesCheckBoxChanged [

	"The catch exception block is because a Spec bug. When you set an empty collectios as a SpDropListPresenter after being populated with some elements, an error appears."

	onlyMyRulesCheckbox state
		ifTrue: [ 
			[ rulesDropList items: CustomRuleGenerator getOnlyCustomRules ]
				on: Exception
				do: [  ] ]
		ifFalse: [ self refreshRulesItems ]
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> getAllRules [

	^ CustomRuleGenerator getAllRules
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initialize [

	super initialize.
	selectedClasses := OrderedCollection new
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initializeLayout [

	self layout: (SpBoxLayout newVertical
			 add: (SpBoxLayout newHorizontal
					  add: #packagesListWithFilter;
					  add: #classesListWithFilter;
					  add: #methodsListWithFilter;
					  spacing: 5;
					  yourself);
			 addLast: (SpBoxLayout newHorizontal
					  add: #rulesDropList;
					  add: #onlyMyRulesCheckbox expand: false;
					  addLast: #applyOnSelectedClassesButton;
					  addLast: #applyOnAllClassesButton;
					  addLast: #openLoaderButton;
					  yourself);
			 yourself)
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initializePresenters [

	self initializeLayout.
	onlyMyRulesCheckbox := self newCheckBox label: 'Only my rules'.
	applyOnSelectedClassesButton := self newButton
		                                label: 'On selected classes';
		                                icon: self class icon;
		                                yourself.
	applyOnAllClassesButton := self newButton
		                           label: 'On all classes';
		                           icon: self class icon;
		                           yourself.
	openLoaderButton := self newButton
		                    label: 'Open Rule Loader';
		                    icon: RewriteRuleLoaderPresenter icon.
	rulesDropList := self newDropList
		                 display: [ :item | item asString ];
		                 items: self getAllRules;
		                 yourself.
	methodsListWithFilter := self newFilteringList.
	methodsListWithFilter listPresenter
		headerTitle: 'Methods';
		display: [ :item | '    ' , item ].
	packagesListWithFilter := self newFilteringList.
	packagesListWithFilter items: RBBrowserEnvironment new packages.
	packagesListWithFilter listPresenter
		headerTitle: 'Packages';
		display: [ :item | item name ];
		displayIcon: [ self iconNamed: #packageIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		beMultipleSelection.
	classesListWithFilter := self newFilteringList.
	classesListWithFilter listPresenter
		headerTitle: 'Classes';
		display: [ :item | item name ];
		displayIcon: [ :elem | elem systemIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		beMultipleSelection.
	self focusOrder
		add: packagesListWithFilter;
		add: classesListWithFilter;
		add: methodsListWithFilter;
		add: rulesDropList;
		add: applyOnSelectedClassesButton;
		add: applyOnAllClassesButton;
		add: openLoaderButton
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title translated;
		initialExtent: 750 @ 500;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #private }
RewriteRuleApplierPresenter >> methodsListWithFilter [

	"This accessors should only be called in the test."

	^ methodsListWithFilter
]

{ #category : #private }
RewriteRuleApplierPresenter >> onlyMyRulesCheckbox [

	"This accessors should only be called in the test."

	^ onlyMyRulesCheckbox
]

{ #category : #actions }
RewriteRuleApplierPresenter >> openLoader [

	^ RewriteRuleLoaderPresenter open
]

{ #category : #actions }
RewriteRuleApplierPresenter >> packagesChanged [

	selectedClasses := packagesListWithFilter listPresenter selectedItems 
		               flatCollect: #classes.
	classesListWithFilter items: selectedClasses.
	classesListWithFilter listPresenter resetListSelection.
	self populateMethodsListWithEnvironmentClasses
]

{ #category : #private }
RewriteRuleApplierPresenter >> packagesListWithFilter [

	"This accessors should only be called in the test."

	^ packagesListWithFilter
]

{ #category : #defaults }
RewriteRuleApplierPresenter >> populateMethodsListWithEnvironmentClasses [

	| methodsInClasses |
	methodsInClasses := selectedClasses flatCollect: #selectors.
	methodsListWithFilter items: methodsInClasses.
	methodsListWithFilter listPresenter resetListSelection
]

{ #category : #actions }
RewriteRuleApplierPresenter >> refreshRulesItems [

	rulesDropList items: self getAllRules
]

{ #category : #private }
RewriteRuleApplierPresenter >> rulesDropdown [

	"This accessors should only be called in the test."

	^ rulesDropList
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplace [

	| changes selectedRule |
	selectedRule := rulesDropList selectedItem new.
	changes := self class
		           obtainChanges: selectedClasses
		           forRule: selectedRule.
	^ (RewriteChangesBrowser changes: changes) open
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplaceOnAllClasses [

	| selectedRule |
	selectedRule := rulesDropList selectedItem new.
	^ self class runReplaceOnAllClasses: selectedRule
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> selectedClasses [

	"This accessors should only be called in the test."

	^ selectedClasses
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> selectedClasses: anObject [

	"This accessors should only be called in the test."

	selectedClasses := anObject
]
