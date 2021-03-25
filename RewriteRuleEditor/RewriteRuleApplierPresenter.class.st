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
		'onlyMyRulesCheckbox',
		'classesListWithFilter',
		'methodsListWithFilter',
		'packagesListWithFilter',
		'rulesDropList'
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
				   add: #rulesDropList;
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

	| changes checker |
	checker := ReSmalllintChecker new
		           rule: { aRule };
		           environment: env;
		           yourself.
	checker run.
	changes := (checker criticsOf: aRule) asArray collect: #change.
	"rewriter := RBParseTreeRewriter new.
	rewriter replace: aRule lhs with: aRule rhs.
	changes := Array with: (RBSmalllintChecker
			            runRule: (RBTransformationRule new
					             rewriteRule: rewriter;
					             yourself)
			            onEnvironment: env) builder."
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

{ #category : #private }
RewriteRuleApplierPresenter >> environment [

	"This accessors should only be called in the test."

	^ environment
]

{ #category : #private }
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

	environment := packagesListWithFilter listPresenter selectedItems 
		               flatCollect: #classes.
	classesListWithFilter items: environment.
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
	methodsInClasses := environment flatCollect: #selectors.
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
		           obtainChanges: (RBClassEnvironment classes: environment)
		           forRule: selectedRule.
	^ (RewriteChangesBrowser changes: changes) open
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplaceOnAllClasses [

	| changes env selectedRule |
	selectedRule := rulesDropList selectedItem new.
	env := RBBrowserEnvironment default forPackages:
		       RPackageOrganizer default packages.
	changes := self class obtainChanges: env forRule: selectedRule.
	^ (RewriteChangesBrowser changes: changes) open
]
