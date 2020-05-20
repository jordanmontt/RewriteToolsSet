"
Basic Transformation Editor
"
Class {
	#name : #BasicTransformationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'searchForPanel',
		'replaceWithPanel',
		'methodCheckBox',
		'saveRuleButton',
		'loadRuleButton',
		'cheatSheet',
		'loadRulesLabel'
	],
	#category : #'RewriteTool-BasicTransformation'
}

{ #category : #defaults }
BasicTransformationPresenter class >> buttonHeight [
	^ 40
]

{ #category : #specs }
BasicTransformationPresenter class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add:
			(SpBoxLayout newVertical
				add: #searchForPanel;
				add: #replaceWithPanel;
				yourself);
		add:
			(SpBoxLayout newVertical
				add: #cheatSheet;
				add: #methodCheckBox height: self buttonHeight;
				add: #saveRuleButton height: self buttonHeight;
				add: #loadRulesLabel
					withConstraints: [ :constraints | 
					constraints
						height: 30;
						padding: 5 ];
				add: #loadRuleButton height: self buttonHeight;
				yourself)
			width: 150;
		"add: #cheatSheet;"
			yourself
]

{ #category : #specs }
BasicTransformationPresenter class >> open [
	<script>
	^ self new openWithSpec
]

{ #category : #defaults }
BasicTransformationPresenter class >> padding [
	^ 3
]

{ #category : #initialization }
BasicTransformationPresenter >> connectPresenters [
	saveRuleButton action: [ self loadRule ].
	loadRuleButton
		whenSelectedItemChangedDo: [ :item | self loadRule: item ]
]

{ #category : #initialization }
BasicTransformationPresenter >> initializeLoadRules [
	| customRules |
	customRules := (RBCustomTransformationRule subclasses
		collect: [ :each | each ]) asOrderedCollection.
	loadRuleButton := self newDropList
		items: customRules;
		yourself
]

{ #category : #initialization }
BasicTransformationPresenter >> initializeMethodCheckBox [
	methodCheckBox := self newCheckBox
		label: 'Method';
		yourself
]

{ #category : #initialization }
BasicTransformationPresenter >> initializePresenters [
	self initializeLoadRules.
	self initializeSearchForPanel.
	self initializeReplaceWithPanel.
	self initializeMethodCheckBox.
	self initializeSaveRuleButton.
	self initilizeCheatSheet.
	self initializeRulesLabel.
	self focusOrder
		add: loadRuleButton;
		add: searchForPanel;
		add: replaceWithPanel;
		add: methodCheckBox;
		add: saveRuleButton;
		add: cheatSheet
]

{ #category : #initialization }
BasicTransformationPresenter >> initializeReplaceWithPanel [
	replaceWithPanel := self instantiate: ReplaceWithPanelPresenter
]

{ #category : #initialization }
BasicTransformationPresenter >> initializeRulesLabel [
	loadRulesLabel := self newLabel
		label: 'Load a rule:';
		yourself
]

{ #category : #initialization }
BasicTransformationPresenter >> initializeSaveRuleButton [
	saveRuleButton := self newButton
		label: 'Save rule';
		yourself
]

{ #category : #initialization }
BasicTransformationPresenter >> initializeSearchForPanel [
	searchForPanel := self instantiate: SearchForPanelPresenter
]

{ #category : #initialization }
BasicTransformationPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Basic Transformation Editor';
		initialExtent: 700 @ 500;
		windowIcon: (self iconNamed: #taskbarIcon);
		askOkToClose: false;
		aboutText: 'A simple UI to create Rewrite Rules'
]

{ #category : #initialization }
BasicTransformationPresenter >> initilizeCheatSheet [
	cheatSheet := self instantiate: MiniCheatSheetRewriteRules
]

{ #category : #actions }
BasicTransformationPresenter >> loadRule [
	self newList
		items: (RBCustomTransformationRule subclasses
		collect: [ :each | each ]) asOrderedCollection;
		openWithSpec
]

{ #category : #actions }
BasicTransformationPresenter >> loadRule: aRuleClass [
	| rule |
	rule := aRuleClass new.
	(UIManager default
		questionWithoutCancel: 'You will lost all unsaved changes.'
		title: 'Do you want to load the selected rule?')
		ifFalse: [ ^ self ].
	searchForPanel codeSource: rule searchFor.
	replaceWithPanel codeSource: rule replaceWith
]

{ #category : #actions }
BasicTransformationPresenter >> saveRule [
	[ CustomRuleGenerator new
		searchFor: searchForPanel codeSource;
		replaceWith: replaceWithPanel codeSource;
		generateCustomRewriteRule.
	^ true ]
		on: Error
		do: [ :e | self error: 'Oops! ' , e className , '!' ].
	^ false
]
