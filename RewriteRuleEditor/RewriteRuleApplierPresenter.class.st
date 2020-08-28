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
		'browseRuleButton',
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
				   addLast: #browseRuleButton;
				   addLast: #editRuleButton;
				   yourself);
		  yourself
]

{ #category : #accessing }
RewriteRuleApplierPresenter class >> icon [
	^ self iconNamed: #objects
]

{ #category : #api }
RewriteRuleApplierPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #testing }
RewriteRuleApplierPresenter >> areSelectedItemsValid: items [
	^ (items allSatisfy: [ :class | class isNotNil ])
		and: [ items isNotEmpty ]
]

{ #category : #actions }
RewriteRuleApplierPresenter >> browseRule [
	Smalltalk tools browser
		openOnClass: rulesDropdown selectedItem
]

{ #category : #actions }
RewriteRuleApplierPresenter >> classesChanged [
	| methodsInClasses |
	(self areSelectedItemsValid: classesList selectedItems)
		ifFalse: [ ^ self ].
	methodsInClasses := OrderedCollection new.
	environment := classesList selectedItems.
	classesList selectedItems
		do: [ :eachClass | methodsInClasses addAll: eachClass selectors ].
	methodsList items: methodsInClasses.
	methodsList resetListSelection
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> connectPresenters [

	packagesList whenSelectionChangedDo: [ self packagesChanged ].
	classesList whenSelectionChangedDo: [ self classesChanged ].
	applyOnSelectedClassesButton action: [ self runReplace ].
	applyOnAllClassesButton action: [ self runReplaceOnAllClasses ].
	browseRuleButton action: [ self browseRule ].
	editRuleButton action: [ 
		self openRuleInBasicEditor.
		self window close ]
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initializePresenters [

	applyOnSelectedClassesButton := self newButton
		                                label: 'On selected classes';
		                                icon: (self class icon);
		                                yourself.
	applyOnAllClassesButton := self newButton
		                           label: 'On all classes';
		                           icon: (self class icon);
		                           yourself.
	browseRuleButton := self newButton
		                    label: 'Browse rule';
		                    icon: (self iconNamed: #smallSystemBrowser);
		                    yourself.
	editRuleButton := self newButton
		                  label: 'Edit rule';
		                  icon: RewriteBasicEditorPresenter icon;
		                  yourself.
	packagesList := self newList
		                items: RBBrowserEnvironment new packages;
		                headerTitle: 'Packages';
		                display: [ :item | item name ];
		                icons: [ self iconNamed: #packageIcon ];
		                sortingBlock: [ :a :b | a name < b name ];
		                beMultipleSelection;
		                yourself.
	classesList := self newList
		               headerTitle: 'Classes';
		               display: [ :item | item name ];
		               icons: [ :elem | elem systemIcon ];
		               sortingBlock: [ :a :b | a name < b name ];
		               beMultipleSelection;
		               yourself.
	methodsList := self newList
		               headerTitle: 'Methods';
		               display: [ :item | '    ' , item ];
		               yourself.
	rulesDropdown := self newDropList
		                 display: [ :item | item asString ];
		                 items: RBCustomTransformationRule subclasses;
		                 yourself.
	environment := OrderedCollection new.
	self focusOrder
		add: packagesList;
		add: classesList;
		add: methodsList;
		add: rulesDropdown;
		add: applyOnSelectedClassesButton;
		add: applyOnAllClassesButton;
		add: browseRuleButton;
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
	changes := Array with: (RBSmalllintChecker
			            runRule: selectedRule
			            onEnvironment: env)
			           builder.
	^ changes
]

{ #category : #actions }
RewriteRuleApplierPresenter >> obtainChanges: env forRule: aRule [

	| changes  |
	changes := Array with:
		           (RBSmalllintChecker
			            runRule: aRule
			            onEnvironment: env) builder.
	^ changes
]

{ #category : #actions }
RewriteRuleApplierPresenter >> openRuleInBasicEditor [
	| aRule editor |
	aRule := rulesDropdown selectedItem new.
	editor := RewriteBasicEditorPresenter new.
	editor searchForPatternCode: aRule searchFor.
	editor replaceWithPatternCode: aRule replaceWith.
	editor openWithSpec
]

{ #category : #actions }
RewriteRuleApplierPresenter >> openRuleInExampleBasedEditor [
	| aRule builder |
	self
		flag: 'Not used method. It will modified to work on later versions'.
	aRule := (self class environment at: rulesDropdown selectedItem) new.
	builder := RewriteRuleBuilderPresenter new.
	builder sourcePanel codeSource: aRule input.
	builder resultPanel codeSource: aRule output.
	builder transformationRule searchForPanel codeSource: aRule searchFor.
	builder transformationRule replaceWithPanel
		codeSource: aRule replaceWith.
	builder transformationRule ruleName: aRule class asString.
	builder transformationRule packageName: aRule class category asString.
	builder openWithSpec
]

{ #category : #actions }
RewriteRuleApplierPresenter >> packagesChanged [
	(self areSelectedItemsValid: packagesList selectedItems)
		ifFalse: [ ^ self ].
	environment removeAll.
	packagesList selectedItems
		do: [ :each | environment addAll: each classes ].
	classesList items: environment.
	classesList resetListSelection
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplace [

	| changes |
	changes := self obtainChanges:
		           (RBClassEnvironment classes: environment).
	(ChangesBrowser changes: changes) open
	"(RewriteRuleChangesBrowser changes: changes) open"
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplaceOnAllClasses [

	| changes env |
	env := RBBrowserEnvironment default forPackages:
		       RPackageOrganizer default packages.
	changes := self obtainChanges: env.
	(ChangesBrowser changes: changes) open
	"(RewriteRuleChangesBrowser changes: changes) open"
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplaceOnAllClasses: aRule [

	| changes env |
	env := RBBrowserEnvironment default forPackages:
		       RPackageOrganizer default packages.
	changes := self obtainChanges: env forRule: aRule.
	(ChangesBrowser changes: changes) open
	"(RewriteRuleChangesBrowser changes: changes) open"
]
