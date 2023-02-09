"
I am a simple tool that allows you to load or delete any of the custom rewrite rules that are saved. I open the saved rule on a RewriteBasicEditorPresenter.

To open me: `RewriteRuleLoaderPresenter open`
"
Class {
	#name : #RTRuleLoaderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
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

{ #category : #specs }
RTRuleLoaderPresenter class >> title [

	^ 'Rewrite rule loader'
]

{ #category : #layout }
RTRuleLoaderPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: rulesTableSelector;
		add: (SpBoxLayout newLeftToRight
			addLast: openInBasicEditorButton;
			addLast: matchToolButton;
			yourself)
		expand: false;
		yourself
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializeButtons [

	openInBasicEditorButton := self instantiate: (OpenRTRuleEditorCommand asSpecButtonForContext: self).
	matchToolButton := self instantiate: (OpenMatchToolCommand asSpecButtonForContext: self)
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializePresenters [

	self initializeTableSelector.
	self initializeButtons
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

{ #category : #accessing }
RTRuleLoaderPresenter >> rhs [

	^ rulesTableSelector rhs
]

{ #category : #actions }
RTRuleLoaderPresenter >> setAllRulesAsTableItems [

	rulesTableSelector refreshRules
]
