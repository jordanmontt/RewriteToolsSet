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
		'editRuleButton',
		'packagesList',
		'classesList',
		'rulesDropdown',
		'methodsList'
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
				   yourself);
		  addLast: (SpBoxLayout newHorizontal
				   add: #rulesDropdown expand: false;
				   addLast: #applyOnSelectedClassesButton;
				   addLast: #applyOnAllClassesButton;
				   addLast: #editRuleButton;
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
	editRuleButton action: [ self openInBasicEditor ]
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

{ #category : #initialization }
RewriteRuleApplierPresenter >> initializePresenters [

	environment := OrderedCollection new.
	applyOnSelectedClassesButton := self newButton
		                                label: 'On selected classes';
		                                icon: self class icon;
		                                yourself.
	applyOnAllClassesButton := self newButton
		                           label: 'On all classes';
		                           icon: self class icon;
		                           yourself.
	editRuleButton := self newButton
		                  label: 'Edit rule';
		                  icon: RewriteBasicEditorPresenter icon;
		                  yourself.
	methodsList := self newList
		               headerTitle: 'Methods';
		               display: [ :item | '    ' , item ];
		               yourself.
	rulesDropdown := self newDropList
		                 display: [ :item | item asString ];
		                 items: RBTransformationRule subclasses;
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
		add: editRuleButton
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
RewriteRuleApplierPresenter >> openInBasicEditor [

	| selectedRule |
	selectedRule := rulesDropdown selectedItem new.
	RewriteRuleLoaderPresenter openRuleInBasicEditor: selectedRule.
	self window close
]

{ #category : #actions }
RewriteRuleApplierPresenter >> openRuleInExampleBasedEditor [

	| aRule builder |
	self flag:
		'Not used method. It will be modified to work on later versions'.
	aRule := (self class environment at: rulesDropdown selectedItem) new.
	builder := RewriteRuleBuilderPresenter new.
	builder sourcePanel codeSource: aRule input.
	builder resultPanel codeSource: aRule output.
	builder transformationRule searchForPanel codeSource: aRule searchFor.
	builder transformationRule replaceWithPanel codeSource:
		aRule replaceWith.
	builder transformationRule ruleName: aRule class asString.
	builder transformationRule packageName: aRule class category asString.
	builder openWithSpec
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
