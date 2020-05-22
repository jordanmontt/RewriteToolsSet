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

{ #category : #defaults }
BasicTransformationPresenter >> defaultRule [
	| searchFor replaceWith |
	replaceWith := '| ``@object |
`.@Statement1.
``@object ifNil: [ ^ self ].
`.@Statement1.
`.@Statement2'.
	searchFor := '| ``@object |
`.@Statement1.
``@object ifNotNil: [ `.@Statement1.
`.@Statement2 ]'.
	^ Dictionary new
		at: #searchFor put: searchFor;
		at: #replaceWith put: replaceWith;
		yourself
]

{ #category : #initialization }
BasicTransformationPresenter >> initializePresenters [
	cheatSheet := self instantiate: MiniCheatSheetRewriteRules.
	searchForPanel := (self instantiate: SearchForPanelPresenter)
		codeSource: (self defaultRule at: #searchFor);
		yourself.
	replaceWithPanel := (self instantiate: ReplaceWithPanelPresenter)
		codeSource: (self defaultRule at: #replaceWith);
		yourself.
	methodCheckBox := self newCheckBox
		label: 'Method';
		yourself.
	loadRuleButton := self newButton
		label: 'Load rule';
		icon: (self iconNamed: #smallInspectIt);
		yourself.
	saveRuleButton := self newButton
		label: 'Save rule';
		icon: (self iconNamed: #smallSaveAs);
		yourself.
	self focusOrder
		add: loadRuleButton;
		add: searchForPanel;
		add: replaceWithPanel;
		add: methodCheckBox;
		add: saveRuleButton;
		add: cheatSheet
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
	[ CustomRuleGenerator new
		searchFor: searchForPanel codeSource;
		replaceWith: replaceWithPanel codeSource;
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
