"
I am a tool that provides a UI for applying a rewrite rule on a certain scope of classes.

In my left column, you can select one or many packages. When you do that, all of their classes will be automatically added to the scope. Also, if you do not want to apply the rewrite rule to all the package's classes, you can select the specific classes on which you want the rewrite rule to be applied.

The methods column shows all the methods the rewrite rule will change. You cannot apply the rewrite rule to a specific method, only to a set of classes.
Remember that multiple selection in supported.

You can open me whit:
`RewriteRuleApplierPresenter open`
"
Class {
	#name : #RTRuleTransformerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'applyOnSelectedClassesButton',
		'applyOnAllClassesButton',
		'openLoaderButton',
		'openRulesTableButton',
		'methodsSelectorPresenter',
		'rulesTablePresenter'
	],
	#category : #'RewriteRuleTools-Transformer'
}

{ #category : #accessing }
RTRuleTransformerPresenter class >> descriptionText [

	^ 'Apply your custom rewrite rules to any packages or classes'
]

{ #category : #accessing }
RTRuleTransformerPresenter class >> icon [

	^ self iconNamed: self iconName
]

{ #category : #accessing }
RTRuleTransformerPresenter class >> iconName [
	^ #objects
]

{ #category : #api }
RTRuleTransformerPresenter class >> open [

	<script>
	^ self new openWithSpec
]

{ #category : #accessing }
RTRuleTransformerPresenter class >> title [

	^ 'Rewrite Rule Applier'
]

{ #category : #initialization }
RTRuleTransformerPresenter >> connectPresenters [

	applyOnSelectedClassesButton action: [ self runReplace ].
	applyOnAllClassesButton action: [ self runReplaceOnAllClasses ].
	openRulesTableButton action: [ self openTableSelectorAsPopover ]
]

{ #category : #initialization }
RTRuleTransformerPresenter >> initializeButtons [

	openRulesTableButton := self newButton.
	openRulesTableButton
		label: 'Select rules to apply...';
		iconNamed: #smallSelect.

	applyOnSelectedClassesButton := self newButton.
	applyOnSelectedClassesButton
		label: 'On selected classes';
		icon: self class icon.

	applyOnAllClassesButton := self newButton.
	applyOnAllClassesButton
		label: 'On all classes';
		icon: self class icon.

	openLoaderButton := self instantiate: (OpenRTRuleLoaderCommand asSpecButtonForContext: self)
]

{ #category : #initialization }
RTRuleTransformerPresenter >> initializeLayout [

	| fixedWidth |
	fixedWidth := 130.

	self layout: (SpBoxLayout newTopToBottom
		add: methodsSelectorPresenter;
		add: (SpBoxLayout newLeftToRight
			add: openRulesTableButton width: fixedWidth;
			addLast: applyOnSelectedClassesButton withConstraints: [ :c | c width: fixedWidth];
			addLast: applyOnAllClassesButton withConstraints: [ :c | c width: fixedWidth];
			addLast: openLoaderButton withConstraints: [ :c | c width: fixedWidth];
			yourself)
		expand: false;
		yourself)
]

{ #category : #initialization }
RTRuleTransformerPresenter >> initializeMethodsSelector [

	methodsSelectorPresenter := MethodsSelectorPresenter new
]

{ #category : #initialization }
RTRuleTransformerPresenter >> initializePresenters [

	self initializeButtons.
	self initializeRulesTableSelector.
	self initializeMethodsSelector.
	self initializeLayout
]

{ #category : #initialization }
RTRuleTransformerPresenter >> initializeRulesTableSelector [

	rulesTablePresenter := self instantiate: RTRulesTableSelectorPresenter
]

{ #category : #initialization }
RTRuleTransformerPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title translated;
		initialExtent: 750 @ 500;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #actions }
RTRuleTransformerPresenter >> openTableSelectorAsPopover [

	| popover wrapper |
	"This is a hack. Wrap the presenter inside a fixed width to have a bigger popover"
	wrapper := SpPresenter new
		layout: (SpBoxLayout newTopToBottom
			add: rulesTablePresenter
			withConstraints: [ :c | c
				width: 400;
				height: 300 ]).

	popover := self newPopover.
	popover
		relativeTo: openRulesTableButton;
		bePositionTop;
		presenter: wrapper.

	popover popup
]

{ #category : #actions }
RTRuleTransformerPresenter >> runReplace [

	| changes selectedRules |
	selectedRules := rulesTablePresenter selectedRules.
	changes := RTRenrakuApplier
		changesOf: methodsSelectorPresenter selectedMethods
		forRules: selectedRules.
	^ (RTChangesBrowser changes: changes) open
]

{ #category : #actions }
RTRuleTransformerPresenter >> runReplaceOnAllClasses [

	| changes |
	changes := RTRenrakuApplier changesOfAllMethodsFor: rulesTablePresenter selectedRules.
	(RTChangesBrowser changes: changes) open
]
