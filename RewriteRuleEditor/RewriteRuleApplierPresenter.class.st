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
		'environment',
		'applyOnSelectedClassesButton',
		'applyOnAllClassesButton',
		'openLoaderButton',
		'rulesDropdown',
		'onlyMyRulesCheckbox',
		'classesListWithFilter',
		'methodsListWithFilter',
		'packagesListWithFilter'
	],
	#category : #'RewriteRuleEditor-Applier'
}

{ #category : #specs }
RewriteRuleApplierPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: (SpBoxLayout newHorizontal
				   add: #packagesListWithFilter;
				   add: #classesListWithFilter;
				   add: #methodsListWithFilter;
				   spacing: 5;
				   yourself);
		  addLast: (SpBoxLayout newHorizontal
				   add: #rulesDropdown;
				   add: #onlyMyRulesCheckbox expand: false;
				   addLast: #applyOnSelectedClassesButton;
				   addLast: #applyOnAllClassesButton;
				   addLast: #openLoaderButton;
				   yourself);
		  yourself
]

{ #category : #accessing }
RewriteRuleApplierPresenter class >> descriptionText [

	^ 'Apply your custom rewrite rules to any packages or classes'
]

{ #category : #accessing }
RewriteRuleApplierPresenter class >> icon [
	^ self iconNamed: #objects
]

{ #category : #api }
RewriteRuleApplierPresenter class >> obtainChanges: env forRule: aRule [

	| changes |
	changes := Array with:
		           (RBSmalllintChecker runRule: aRule onEnvironment: env)
			           builder.
	^ changes
]

{ #category : #api }
RewriteRuleApplierPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #api }
RewriteRuleApplierPresenter class >> runReplaceOnAllClasses: aRule [

	| changes env |
	env := RBBrowserEnvironment default forPackages:
		       RPackageOrganizer default packages.
	changes := self obtainChanges: env forRule: aRule.
	(RewriteChangesBrowser changes: changes) open
]

{ #category : #accessing }
RewriteRuleApplierPresenter class >> title [

	^ 'Rewrite Rule Applier'
]

{ #category : #actions }
RewriteRuleApplierPresenter >> classesChanged [

	environment := classesListWithFilter listPresenter selectedItems.
	self populateMethodsListWithEnvironmentClasses
]

{ #category : #accessing }
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
			[ rulesDropdown items: CustomRuleGenerator getOnlyCustomRules ]
				on: Exception
				do: [  ] ]
		ifFalse: [ self refreshRulesItems ]
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> environment [

	"This accessors should only be called in the test."

	^ environment
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> environment: aCollection [

	"This accessors should only be called in the test."

	environment := aCollection
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> getAllRules [

	^ CustomRuleGenerator getAllRules
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initializePresenters [

	environment := OrderedCollection new.
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
	rulesDropdown := self newDropList
		                 display: [ :item | item asString ];
		                 items: self getAllRules;
		                 yourself.
	methodsListWithFilter := self instantiate: SpFilteringListPresenter.
	methodsListWithFilter listPresenter
		headerTitle: 'Methods';
		display: [ :item | '    ' , item ].
	packagesListWithFilter := self instantiate: SpFilteringListPresenter.
	packagesListWithFilter items: RBBrowserEnvironment new packages.
	packagesListWithFilter listPresenter
		headerTitle: 'Packages';
		display: [ :item | item name ];
		icons: [ self iconNamed: #packageIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		beMultipleSelection.
	classesListWithFilter := self instantiate: SpFilteringListPresenter.
	classesListWithFilter listPresenter
		headerTitle: 'Classes';
		display: [ :item | item name ];
		icons: [ :elem | elem systemIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		beMultipleSelection.
	self focusOrder
		add: packagesListWithFilter;
		add: classesListWithFilter;
		add: methodsListWithFilter;
		add: rulesDropdown;
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

{ #category : #accessing }
RewriteRuleApplierPresenter >> methodsListWithFilter [

	"This accessors should only be called in the test."

	^ methodsListWithFilter
]

{ #category : #actions }
RewriteRuleApplierPresenter >> obtainChanges: env [

	| changes selectedRule |
	selectedRule := rulesDropdown selectedItem new.
	changes := Array with:
		           (RBSmalllintChecker
			            runRule: selectedRule
			            onEnvironment: env) builder.
	^ changes
]

{ #category : #accessing }
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

	environment := packagesListWithFilter listPresenter selectedItems 
		               flatCollect: #classes.
	classesListWithFilter items: environment.
	classesListWithFilter listPresenter resetListSelection.
	self populateMethodsListWithEnvironmentClasses
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> packagesListWithFilter [

	"This accessors should only be called in the test."

	^ packagesListWithFilter
]

{ #category : #defaults }
RewriteRuleApplierPresenter >> populateMethodsListWithEnvironmentClasses [

	| methodsInClasses |
	methodsInClasses := environment flatCollect: #selectors.
	methodsListWithFilter items: methodsInClasses.
	methodsListWithFilter listPresenter resetListSelection
]

{ #category : #actions }
RewriteRuleApplierPresenter >> refreshRulesItems [

	rulesDropdown items: self getAllRules
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> rulesDropdown [

	"This accessors should only be called in the test."

	^ rulesDropdown
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplace [

	| changes |
	changes := self obtainChanges:
		           (RBClassEnvironment classes: environment).
	^ (RewriteChangesBrowser changes: changes) open
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplaceOnAllClasses [

	| changes env |
	env := RBBrowserEnvironment default forPackages:
		       RPackageOrganizer default packages.
	changes := self obtainChanges: env.
	^ (RewriteChangesBrowser changes: changes) open
]
