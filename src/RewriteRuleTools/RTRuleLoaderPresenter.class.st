"
I am a simple tool that allows you to load or delete any of the custom rewrite rules that are saved. I open the saved rule on a RewriteBasicEditorPresenter.

To open me: `RewriteRuleLoaderPresenter open`
"
Class {
	#name : #RTRuleLoaderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'deleteButton',
		'refreshItemsButton',
		'openInBasicEditorButton',
		'matchToolButton',
		'rulesTableSelector'
	],
	#category : #'RewriteRuleTools-Loader'
}

{ #category : #accessing }
RTRuleLoaderPresenter class >> descriptionText [

	^ 'Loads and deletes custom rewrite rules'
]

{ #category : #accessing }
RTRuleLoaderPresenter class >> icon [

	^ self iconNamed: self iconName
]

{ #category : #accessing }
RTRuleLoaderPresenter class >> iconName [

	^ #smallLoadProject
]

{ #category : #api }
RTRuleLoaderPresenter class >> open [

	<script>
	^ RTApplication new startRuleLoader
]

{ #category : #specs }
RTRuleLoaderPresenter class >> title [

	^ 'Rewrite rule loader'
]

{ #category : #initialization }
RTRuleLoaderPresenter >> connectPresenters [

	deleteButton action: [ self deleteButtonAction ].
	refreshItemsButton action: [ self setAllRulesAsTableItems ]
]

{ #category : #actions }
RTRuleLoaderPresenter >> deleteButtonAction [

	| answer |
	rulesTableSelector selectedRulesAsFileReference ifEmpty: [ 
		self noRuleIsSelectedAlert.
		^ self ].
	
	answer := rulesTableSelector selectedRules size > 1
		ifTrue: [ (UIManager default
			confirm: ('Are you sure you want to delete the selected {1} rules?'
				format: { rulesTableSelector selectedRules size })
			label: ('Delete {1} rules?' format: { rulesTableSelector selectedRules size })) ]
		ifFalse: [ (UIManager default
			confirm: 'Are you sure you want to delete the selected rule?'
			label: 'Delete?')   ].
	answer ifFalse: [ ^ self ].
	self deleteRule
]

{ #category : #actions }
RTRuleLoaderPresenter >> deleteRule [

	rulesTableSelector selectedRulesAsFileReference do: [ :each | each delete ].
	self setAllRulesAsTableItems
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializeButtons [

	openInBasicEditorButton := self instantiate: (OpenRTRuleEditorCommand asSpecButtonForContext: self).
	matchToolButton := self instantiate: (OpenMatchToolCommand asSpecButtonForContext: self).

	deleteButton := self newButton.
	deleteButton
		label: 'Delete';
		icon: (self iconNamed: #smallDelete).

	refreshItemsButton := self newButton.
	refreshItemsButton
		label: 'Refresh';
		icon: (self iconNamed: #smallUpdate)
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: rulesTableSelector;
		add: (SpBoxLayout newLeftToRight
			addLast: openInBasicEditorButton;
			addLast: matchToolButton;
			addLast: deleteButton;
			addLast: refreshItemsButton;
			yourself)
		expand: false;
		yourself)
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializePresenters [
	
	self initializeTableSelector.
	self initializeButtons.
	self initializeLayout
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializeTableSelector [

	rulesTableSelector := self instantiate: RTRulesTableSelectorPresenter
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 700 @ 450;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #accessing }
RTRuleLoaderPresenter >> lhs [

	^ rulesTableSelector lhs
]

{ #category : #alerts }
RTRuleLoaderPresenter >> noRuleIsSelectedAlert [

	UIManager default alert: 'You have to select a rule.'
]

{ #category : #accessing }
RTRuleLoaderPresenter >> rhs [

	^ rulesTableSelector rhs
]

{ #category : #actions }
RTRuleLoaderPresenter >> setAllRulesAsTableItems [

	rulesTableSelector refreshRules
]
