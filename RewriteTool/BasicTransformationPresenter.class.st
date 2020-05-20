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
		'cheatSheet'
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
	saveRuleButton action: [ self saveRule ].
	loadRuleButton action: [ self loadRule ]
]

{ #category : #initialization }
BasicTransformationPresenter >> initializeLoadButton [
	loadRuleButton := self newButton
		label: 'Load rule';
		icon: (self iconNamed: #smallInspectIt);
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
	self initializeLoadButton.
	self initializeSearchForPanel.
	self initializeReplaceWithPanel.
	self initializeMethodCheckBox.
	self initializeSaveRuleButton.
	self initilizeCheatSheet.
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
BasicTransformationPresenter >> initializeSaveRuleButton [
	saveRuleButton := self newButton
		label: 'Save rule';
		icon: (self iconNamed: #smallSaveAs);
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
	LoadRulePresenter open
]

{ #category : #api }
BasicTransformationPresenter >> replaceWithCode: aCode [
	replaceWithPanel codeSource: aCode
]

{ #category : #actions }
BasicTransformationPresenter >> saveRule [
	self flag: #accessCodePresenterText.
	[ CustomRuleGenerator new
		searchFor: searchForPanel codePresenter text;
		replaceWith: replaceWithPanel codePresenter text;
		generateCustomRewriteRule.
	^ true ]
		on: Error
		do: [ :e | self error: 'Oops! ' , e className , '!' ].
	^ false
]

{ #category : #api }
BasicTransformationPresenter >> searchForCode: aCode [
	searchForPanel codeSource: aCode
]
