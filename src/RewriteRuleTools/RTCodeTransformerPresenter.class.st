"
I am a tool that provides a UI for applying a rewrite rule on a certain scope of classes.

In my left column, you can select one or many packages. When you do that, all of their classes will be automatically added to the scope. Also, if you do not want to apply the rewrite rule to all the package's classes, you can select the specific classes on which you want the rewrite rule to be applied.

The methods column shows all the methods the rewrite rule will change. You cannot apply the rewrite rule to a specific method, only to a set of classes.
Remember that multiple selection in supported.

You can open me whit:
`RewriteRuleApplierPresenter open`
"
Class {
	#name : #RTCodeTransformerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'applyOnSelectedClassesButton',
		'applyOnAllClassesButton',
		'openRulesTableButton',
		'methodsSelectorPresenter',
		'rulesTablePresenter'
	],
	#category : #'RewriteRuleTools-Transformer'
}

{ #category : #accessing }
RTCodeTransformerPresenter class >> descriptionText [

	^ 'Apply your custom rewrite rules to any packages or classes'
]

{ #category : #accessing }
RTCodeTransformerPresenter class >> icon [

	^ self iconNamed: self iconName
]

{ #category : #accessing }
RTCodeTransformerPresenter class >> iconName [
	^ #objects
]

{ #category : #specs }
RTCodeTransformerPresenter class >> title [

	^ 'Rewrite Transformer'
]

{ #category : #initialization }
RTCodeTransformerPresenter >> connectPresenters [

	applyOnSelectedClassesButton action: [ self runReplace ].
	applyOnAllClassesButton action: [ self runReplaceOnAllClasses ].
	openRulesTableButton action: [ self openTableSelectorAsPopover ]
]

{ #category : #initialization }
RTCodeTransformerPresenter >> initializeButtons [

	openRulesTableButton := self newButton.
	openRulesTableButton
		label: 'Select rules';
		iconName: #smallSelect.

	applyOnSelectedClassesButton := self newButton.
	applyOnSelectedClassesButton
		label: 'Apply on selected classes';
		icon: self class icon.

	applyOnAllClassesButton := self newButton.
	applyOnAllClassesButton
		label: 'Apply on all classes';
		icon: self class icon
]

{ #category : #initialization }
RTCodeTransformerPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: methodsSelectorPresenter;
		add: (SpBoxLayout newLeftToRight
			add: openRulesTableButton expand: false;
			addLast: applyOnSelectedClassesButton;
			addLast: applyOnAllClassesButton;
			yourself)
		expand: false;
		yourself)
]

{ #category : #initialization }
RTCodeTransformerPresenter >> initializePresenters [
	
	self initializeButtons.
	self initializeRulesTableSelector.
	self initializeScopeSelector.

	self initializeStyles.
	self initializeLayout
]

{ #category : #initialization }
RTCodeTransformerPresenter >> initializeRulesTableSelector [

	rulesTablePresenter := self instantiate: RTRulesTableSelectorPresenter
]

{ #category : #initialization }
RTCodeTransformerPresenter >> initializeScopeSelector [

	methodsSelectorPresenter := self instantiate: ScopeSelectorPresenter
]

{ #category : #initialization }
RTCodeTransformerPresenter >> initializeStyles [

	openRulesTableButton addStyle: 'buttonStyle'.
	applyOnSelectedClassesButton addStyle: 'buttonStyle'.
	applyOnAllClassesButton addStyle: 'buttonStyle'
]

{ #category : #initialization }
RTCodeTransformerPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title translated;
		initialExtent: 750 @ 500;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #actions }
RTCodeTransformerPresenter >> openTableSelectorAsPopover [

	| popover wrapper |
	"This is a hack. Wrap the presenter inside a fixed width to have a bigger popover"
	wrapper := SpPresenter new.
	wrapper
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
RTCodeTransformerPresenter >> runReplace [

	| changes selectedRules |
	selectedRules := rulesTablePresenter selectedRules.
	changes := RTAbstractApplier defaultEngineApplier
		calculateChangesForClasses: methodsSelectorPresenter selectedClasses
		transformationRules: selectedRules.
	
	^ (RTChangesBrowser changes: changes) open
]

{ #category : #actions }
RTCodeTransformerPresenter >> runReplaceOnAllClasses [

	| changes |
	changes := RTAbstractApplier defaultEngineApplier
		calculateAllChangesForRules: rulesTablePresenter selectedRules.
	
	(RTChangesBrowser changes: changes) open
]
