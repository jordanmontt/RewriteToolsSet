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
			width: 200;
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
BasicTransformationPresenter >> initializePresenters [
	searchForPanel := self instantiate: SearchForPanelPresenter.
	replaceWithPanel := self instantiate: ReplaceWithPanelPresenter.
	methodCheckBox := self newCheckBox
		label: 'Method';
		yourself.
	saveRuleButton := self newButton
		label: 'Save rule';
		yourself.
	loadRuleButton := self newButton
		label: 'Load Rule';
		yourself.
	cheatSheet := self instantiate: MiniCheatSheetRewriteRules
]

{ #category : #initialization }
BasicTransformationPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Basic Transformation Editor';
		initialExtent: 800 @ 500;
		windowIcon: (self iconNamed: #taskbarIcon);
		askOkToClose: false;
		aboutText: 'A simple UI to create Rewrite Rules'
]
