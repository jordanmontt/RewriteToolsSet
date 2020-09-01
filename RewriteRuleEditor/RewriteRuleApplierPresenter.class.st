"
A RewriteBrowserPresenter is a tool that provides GUI for applying rewrite rule on certain scope of classes. If you select a package, all of their classes will be added to the scope. If you select a class, the scope will contain only that class. Multiple selection in suported.

To open:
RewriteBrowserPresenter open
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

	| methodsInClasses |
	environment := classesList selectedItems.
	methodsInClasses := (environment collect: #selectors) flattened.
	methodsList items: methodsInClasses.
	methodsList resetListSelection
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> connectPresenters [

	packagesList whenSelectionChangedDo: [ self packagesChanged ].
	classesList whenSelectionChangedDo: [ self classesChanged ].
	applyOnSelectedClassesButton action: [ self runReplace ].
	applyOnAllClassesButton action: [ self runReplaceOnAllClasses ].
	editRuleButton action: [ self openInBasicEditor ]
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
		                 items: RBCustomTransformationRule subclasses;
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
	classesList resetListSelection
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplace [

	| changes |
	changes := self obtainChanges:
		           (RBClassEnvironment classes: environment).
	(RewriteChangesBrowser changes: changes) open
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplaceOnAllClasses [

	| changes env |
	env := RBBrowserEnvironment default forPackages:
		       RPackageOrganizer default packages.
	changes := self obtainChanges: env.
	(RewriteChangesBrowser changes: changes) open
]
