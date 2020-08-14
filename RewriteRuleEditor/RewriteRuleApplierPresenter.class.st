"
A RewriteBrowserPresenter is a tool that provides GUI for applying rewrite rule on certain scope of classes. If you select a package, all of their classes will be added to the scope. If you select a class, the scope will contain only that class. Multiple selection in suported.

To open:
RewriteBrowserPresenter open
"
Class {
	#name : #RewriteRuleApplierPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'rules',
		'packages',
		'classes',
		'methods',
		'environment',
		'buttonBar'
	],
	#category : #'RewriteRuleEditor-Applier'
}

{ #category : #accessing }
RewriteRuleApplierPresenter class >> buttonHeight [
	^ 40
]

{ #category : #accessing }
RewriteRuleApplierPresenter class >> buttonWidth [
	^ 150
]

{ #category : #specs }
RewriteRuleApplierPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #packages;
				add: #classes;
				add: #methods;
				yourself);
		addLast:
			(SpBoxLayout newHorizontal
				add: #rules expand: false;
				add: #buttonBar;
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

{ #category : #accessing }
RewriteRuleApplierPresenter class >> rulesWidth [
	^ 225
]

{ #category : #testing }
RewriteRuleApplierPresenter >> areSelectedItemsValid: items [
	^ (items allSatisfy: [ :class | class isNotNil ])
		and: [ items isNotEmpty ]
]

{ #category : #actions }
RewriteRuleApplierPresenter >> browseRule [
	Smalltalk tools browser
		openOnClass: rules selectedItem
]

{ #category : #actions }
RewriteRuleApplierPresenter >> classesChanged [
	| methodsInClasses |
	(self areSelectedItemsValid: classes selectedItems)
		ifFalse: [ ^ self ].
	methodsInClasses := OrderedCollection new.
	environment := classes selectedItems.
	classes selectedItems
		do: [ :eachClass | methodsInClasses addAll: eachClass selectors ].
	methods items: methodsInClasses.
	methods resetListSelection
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> connectPresenters [
	packages whenSelectionChangedDo: [ self packagesChanged ].
	classes whenSelectionChangedDo: [ self classesChanged ]
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initializePresenters [

	buttonBar := self newButtonBar
		             add: (self newButton
				              label: 'Apply rule';
				              icon: (self iconNamed: #smallOk);
				              action: [ self runReplace ];
				              yourself);
		             add: (self newButton
				              label: 'Browse rule';
				              icon: (self iconNamed: #smallSystemBrowser);
				              action: [ self browseRule ];
				              yourself);
		             add: (self newButton
				              label: 'Edit rule';
				              icon: RewriteBasicEditorPresenter icon;
				              action: [ 
					              self openRuleInBasicEditor.
					              self window close ];
				              yourself);
		             yourself.
	packages := self newList
		            items: RBBrowserEnvironment new packages;
		            headerTitle: 'Packages';
		            display: [ :item | item name ];
		            icons: [ self iconNamed: #packageIcon ];
		            sortingBlock: [ :a :b | a name < b name ];
		            beMultipleSelection;
		            yourself.
	classes := self newList
		           headerTitle: 'Classes';
		           display: [ :item | item name ];
		           icons: [ :elem | elem systemIcon ];
		           sortingBlock: [ :a :b | a name < b name ];
		           beMultipleSelection;
		           yourself.
	methods := self newList
		           headerTitle: 'Methods';
		           display: [ :item | '    ' , item ];
		           yourself.
	rules := self newDropList
		         display: [ :item | item asString ];
		         items: RBCustomTransformationRule subclasses;
		         yourself.
	environment := OrderedCollection new.
	self focusOrder
		add: packages;
		add: classes;
		add: methods;
		add: rules;
		add: buttonBar
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
	selectedRule := rules selectedItem new.
	changes := Array with: (RBSmalllintChecker
			            runRule: selectedRule
			            onEnvironment:
			            (RBClassEnvironment classes: env)) builder.
	^ changes
]

{ #category : #actions }
RewriteRuleApplierPresenter >> openRuleInBasicEditor [
	| aRule editor |
	aRule := rules selectedItem new.
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
	aRule := (self class environment at: rules selectedItem) new.
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
	(self areSelectedItemsValid: packages selectedItems)
		ifFalse: [ ^ self ].
	environment removeAll.
	packages selectedItems
		do: [ :each | environment addAll: each classes ].
	classes items: environment.
	classes resetListSelection
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplace [

	| changes |
	changes := self obtainChanges: environment.
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
