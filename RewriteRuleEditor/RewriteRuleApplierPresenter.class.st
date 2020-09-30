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
		'packagesList',
		'classesList',
		'rulesDropdown',
		'methodsList',
		'onlyMyRulesCheckbox'
	],
	#category : #'RewriteRuleEditor-Applier'
}

{ #category : #specs }
RewriteRuleApplierPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: (SpBoxLayout newHorizontal
				   add: #packagesList;
				   add: #classesList;
				   add: #methodsList;
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

{ #category : #actions }
RewriteRuleApplierPresenter >> classesChanged [

	environment := classesList selectedItems.
	self populateMethodsListWithEnvironmentClasses
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> classesList [

	"This accessors should only be called in the test."

	^ classesList
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> connectPresenters [

	packagesList whenSelectionChangedDo: [ self packagesChanged ].
	classesList whenSelectionChangedDo: [ self classesChanged ].
	applyOnSelectedClassesButton action: [ self runReplace ].
	applyOnAllClassesButton action: [ self runReplaceOnAllClasses ].
	openLoaderButton action: [ self openLoader ].
	onlyMyRulesCheckbox whenActivatedDo: [ 
		self excludeDemoRulesFromRulesList ].
	onlyMyRulesCheckbox whenDeactivatedDo: [ self refreshRulesItems ]
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

{ #category : #actions }
RewriteRuleApplierPresenter >> excludeDemoRulesFromRulesList [

	"The try catch is because the message rulesDropdown emptyList is some times giving an error. It is a Spec problem"

	| filteredRules |
	filteredRules := self getAllRules reject: [ :aRule | 
		                 aRule new isDemoRule ].
	[ rulesDropdown items: filteredRules ]
		on: Exception
		do: [  ]
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> getAllRules [

	^ RBCustomTransformationRule subclasses
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
	methodsList := self newList
		               headerTitle: 'Methods';
		               display: [ :item | '    ' , item ];
		               yourself.
	rulesDropdown := self newDropList
		                 display: [ :item | item asString ];
		                 items: self getAllRules;
		                 yourself.
	packagesList := self newList.
	packagesList
		items: RBBrowserEnvironment new packages;
		headerTitle: 'Packages';
		display: [ :item | item name ];
		icons: [ self iconNamed: #packageIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		beMultipleSelection.
	classesList := self newList.
	classesList
		headerTitle: 'Classes';
		display: [ :item | item name ];
		icons: [ :elem | elem systemIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		beMultipleSelection.
	self focusOrder
		add: packagesList;
		add: classesList;
		add: methodsList;
		add: rulesDropdown;
		add: applyOnSelectedClassesButton;
		add: applyOnAllClassesButton;
		add: openLoaderButton
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Rewrite Rule Applier' translated;
		initialExtent: 750 @ 500;
		windowIcon: (self class icon);
		askOkToClose: false;
		aboutText: 'Apply your custom rewrite rules to packages or classes.'
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> methodsList [

	"This accessors should only be called in the test."

	^ methodsList
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

{ #category : #actions }
RewriteRuleApplierPresenter >> openLoader [

	^ RewriteRuleLoaderPresenter open
]

{ #category : #actions }
RewriteRuleApplierPresenter >> packagesChanged [

	environment := (packagesList selectedItems collect: #classes)
		               flattened.
	classesList items: environment.
	classesList resetListSelection.
	self populateMethodsListWithEnvironmentClasses
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> packagesList [

	"This accessors should only be called in the test."

	^ packagesList
]

{ #category : #defaults }
RewriteRuleApplierPresenter >> populateMethodsListWithEnvironmentClasses [

	| methodsInClasses |
	methodsInClasses := (environment collect: #selectors) flattened.
	methodsList items: methodsInClasses.
	methodsList resetListSelection
]

{ #category : #actions }
RewriteRuleApplierPresenter >> refreshRulesItems [

	rulesDropdown items: self getAllRules
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
