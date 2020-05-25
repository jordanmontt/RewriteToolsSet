"
A RewriteRuleBrowser is a tool that provides GUI for applying rewrite rule on certain scope of packages / classes / methods.

To open do next: RewriteRuleBrowser new openWithSpec

Instance Variables
	applyButton:		<ButtonModel>
	browseButton:		<ButtonModel>
	chosenMethods:		<OrderedCollection>
	classes:		<ListModel>
	methods:		<ListModel>
	packages:		<ListModel>
	rules:		<ListModel>
	scopeButton:		<ButtonModel>

applyButton
	- applies selected rule to selected scope

browseButton
	- browses selected rule class

chosenMethods
	- selected methods (scope)

classes
	- list of classes of selected package

methods
	- list of methods of selected class

packages
	- list of all packages in this image

rules
	- list of rewrie rules that were created using RewriteRuleBuilder tool

scopeButton
	- browses selected scope (package / class)

"
Class {
	#name : #RewriteBrowserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'rules',
		'packages',
		'classes',
		'methods',
		'environment',
		'checkbox',
		'actionBar'
	],
	#category : #'RewriteTool-ExampleBasedEditor'
}

{ #category : #accessing }
RewriteBrowserPresenter class >> buttonHeight [
	^ 40
]

{ #category : #accessing }
RewriteBrowserPresenter class >> buttonWidth [
	^ 150
]

{ #category : #specs }
RewriteBrowserPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #packages;
				add: #classes;
				add: #methods;
				yourself);
		add:
			(SpBoxLayout newHorizontal
				add: #checkbox width: 110;
				add: #rules width: 200;
				add: #actionBar;
				yourself)
			height: self buttonHeight;
		yourself
]

{ #category : #'world menu' }
RewriteBrowserPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #RewriteRuleBrowser)
		parent: #Tools;
		order: 40;
		action: [ self new openWithSpec ];
		icon: (self iconNamed: #configIcon)
]

{ #category : #api }
RewriteBrowserPresenter class >> open [
	<script>
	^ self new openWithSpec
]

{ #category : #accessing }
RewriteBrowserPresenter class >> rulesWidth [
	^ 225
]

{ #category : #actions }
RewriteBrowserPresenter >> allRules [
	
	^ OrderedCollection new
		addAll: self demoRules;
		addAll: self customRules;
		yourself.
	
]

{ #category : #actions }
RewriteBrowserPresenter >> applyRule [
	rules selectedItem
		ifNil: [ UIManager default alert: 'You must select a rule to apply.' ]
		ifNotNil: [ self applyRule: rules selectedItem on: environment ]
]

{ #category : #defaults }
RewriteBrowserPresenter >> applyRule: aRuleClass on: aCollection [
	| result |
	result := self getResultOfRule: aRuleClass appliedTo: aCollection.
	(ChangesBrowser changes: result builder changes) open
]

{ #category : #testing }
RewriteBrowserPresenter >> areSelectedItemsValid: items [
	^ (items allSatisfy: [ :class | class isNotNil ])
		and: [ items isNotEmpty ]
]

{ #category : #actions }
RewriteBrowserPresenter >> browseRule [
	Smalltalk tools browser
		openOnClass: (Smalltalk globals at: rules selectedItem)
]

{ #category : #accessing }
RewriteBrowserPresenter >> browsedEnvironment [
	^ RBBrowserEnvironment new
]

{ #category : #actions }
RewriteBrowserPresenter >> classesChanged [
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
RewriteBrowserPresenter >> connectPresenters [
	packages whenSelectionChangedDo: [ self packagesChanged ].
	classes whenSelectionChangedDo: [ self classesChanged ].
	checkbox
		whenActivatedDo: [ rules items: self customRules ];
		whenDeactivatedDo: [ rules items: self allRules ]
]

{ #category : #defaults }
RewriteBrowserPresenter >> customRules [
	^ (RBCustomTransformationRule subclasses
		collect: [ :each | each name ] )asOrderedCollection 
]

{ #category : #defaults }
RewriteBrowserPresenter >> demoRules [
	^ (RBTransformationRule subclasses collect: [ :each | each name ])
		asOrderedCollection
]

{ #category : #actions }
RewriteBrowserPresenter >> editRule [
	| aRule builder |
	aRule := (Smalltalk globals at: rules selectedItem) new.
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

{ #category : #defaults }
RewriteBrowserPresenter >> getResultOfRule: aRuleClass appliedTo: aCollection [
	^ RBSmalllintChecker
		runRule: (Smalltalk globals at: aRuleClass) new
		onEnvironment: (RBClassEnvironment classes: aCollection)
]

{ #category : #initialization }
RewriteBrowserPresenter >> initializePresenters [
	actionBar := self newButtonBar
		add:
			(self newButton
				label: 'Apply rule';
				icon: (self iconNamed: #smallOk);
				action: [ self applyRule ];
				yourself);
		add:
			(self newButton
				label: 'Browse rule';
				icon: (self iconNamed: #smallSystemBrowser);
				action: [ self browseRule ];
				yourself);
		add:
			(self newButton
				label: 'Edit rule';
				icon: (self iconNamed: #smallInspectIt);
				action: [ self editRule ];
				yourself);
		yourself.
	packages := self newList
		items: self browsedEnvironment packages;
		headerTitle: 'Packages';
		display: [ :item | item name ];
		icons: [ self iconNamed: #packageIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		enableItemSubstringFilter;
		beMultipleSelection;
		yourself.
	classes := self newList
		headerTitle: 'Classes';
		display: [ :item | item name ];
		icons: [ self iconNamed: #classIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		enableItemSubstringFilter;
		beMultipleSelection;
		yourself.
	methods := self newList
		headerTitle: 'Methods';
		display: [ :item | '    ' , item ];
		enableItemSubstringFilter;
		yourself.
	rules := self newDropList
		display: [ :item | item asString ];
		items: self allRules;
		yourself.
	checkbox := self newCheckBox
		label: 'Only my rules';
		yourself.
	environment := OrderedCollection new.
	self focusOrder
		add: packages;
		add: classes;
		add: methods;
		add: checkbox;
		add: rules;
		add: actionBar
]

{ #category : #initialization }
RewriteBrowserPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Rewrite Rule Browser' translated;
		initialExtent: 750 @ 500;
		windowIcon: (self iconNamed: #taskbarIcon);
		askOkToClose: false;
		aboutText: 'Apply your custom rewrite rules to packages or classes.'
]

{ #category : #actions }
RewriteBrowserPresenter >> packagesChanged [
	(self areSelectedItemsValid: packages selectedItems)
		ifFalse: [ ^ self ].
	environment removeAll.
	packages selectedItems
		do: [ :each | environment addAll: each classes ].
	classes items: environment.
	classes resetListSelection
]
