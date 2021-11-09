"
I am a tool that allows you to create, apply and save custom rewrite rules. To open me go to my class side method `open`.

You can write the rewrite rule on searchFor's and replaceWith's editors. When the rewrite rule is written, you can click on 'Open Applier' for open a tool that allows you to apply the rewrite rule to specific classes. Or you just can click on 'Apply on all classes' to apply the rewrite rule to all system's classes.

The Applier only works with saved rules, so remember to save your rule before open it. To apply the rule to all system's classes you do not need to save the rule.

The rule is saved as a subclass of `RBTransformationRule` so the name you enter must be a valid class name.

If you want to edit an already saved rewrite rule, just click on 'Open Loader' and select your rule. When you open me with an already saved rule and click the 'Save rule' button, the name of the rule is entered by default. If you save a rewrite rule with the same name it will be updated.

Click on MatchTool to open a tool that allows you to match your rule with a block of Pharo's code.
"
Class {
	#name : #RTBasicEditorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'cheatSheet',
		'saveButton',
		'loadButton',
		'expressionFinderButton',
		'helpButton',
		'matcherButton',
		'searchForEditor',
		'replaceWithEditor',
		'openApplierButton',
		'applyButton',
		'builderButton',
		'loadedRule',
		'isMethodCheckbox'
	],
	#category : #'RewriteRuleTools-BasicEditor'
}

{ #category : #accessing }
RTBasicEditorPresenter class >> descriptionText [ 

	^ 'A tool to build and apply custom Rewrite Rules.'
]

{ #category : #accesing }
RTBasicEditorPresenter class >> helpText [

	^ '` = meta var

@ = list

` = recurse into

. = statement

# = literal'
]

{ #category : #accessing }
RTBasicEditorPresenter class >> icon [

	^ self iconNamed: self iconName
]

{ #category : #accessing }
RTBasicEditorPresenter class >> iconName [
	^ #workspaceIcon
]

{ #category : #'world menu' }
RTBasicEditorPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #RewriteRuleEditor)
		action: [ self open ];
		order: 30;
		parent: #Tools;
		help: self descriptionText;
		icon: self icon
]

{ #category : #specs }
RTBasicEditorPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #accessing }
RTBasicEditorPresenter class >> title [

	^ 'Rewrite Basic Editor'
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializeButtons [

	loadButton := self instantiate: (OpenRTRuleLoaderCommand asSpecButtonForContext: self).
	saveButton := self instantiate: (SaveRuleCommand asSpecButtonForContext: self).
	openApplierButton := self instantiate: (OpenRTApplierCommand asSpecButtonForContext: self).
	matcherButton := self instantiate: (OpenMatchToolCommand asSpecButtonForContext: self).
	applyButton := self instantiate: (ApplyRuleOnAllClassesCommand asSpecButtonForContext: self).
	helpButton := self instantiate: (OpenRTHelpBrowserCommand asSpecButtonForContext: self).
	builderButton := self instantiate: (OpenRTRuleBuilderCommand asSpecButtonForContext: self).
	expressionFinderButton := self instantiate: (OpenRTExpressionFinderCommand asSpecButtonForContext: self).
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializeLayout [

	| tempLayout|
	tempLayout := SpPanedLayout newLeftToRight
		add: (SpPanedLayout newVertical
			add: searchForEditor;
			add: replaceWithEditor;
			yourself);
		add: (SpBoxLayout newTopToBottom
			add: isMethodCheckbox expand: false;
			add: helpButton expand: false;
			add: cheatSheet expand: true;
			add: saveButton expand: false;
			add: openApplierButton expand: false;
			add: applyButton expand: false;
			add: expressionFinderButton expand: false;
			add: matcherButton expand: false;
			add: builderButton expand: false;
			add: loadButton expand: false;
			yourself);
		positionOfSlider: 75 percent;
		yourself.
	self layout: (tempLayout)
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializeMethodCheckbox [

	isMethodCheckbox := self newCheckBox.
	isMethodCheckbox label: 'Is rule for method?'
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializePresenters [

	self initializeMethodCheckbox.
	self initializeTextCheatSheet.
	self initializeRuleEditors.
	self initializeButtons.
	self initializeLayout
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializeRuleEditors [

	searchForEditor := self instantiate: RTSearchForPanel.
	replaceWithEditor := self instantiate: RTReplaceWithPanel
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializeTextCheatSheet [

	cheatSheet := self instantiate: RTCheatSheetPresenter
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializeWindow: aWindowPresenter [

	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter
		title: self class title;
		initialExtent: 50 @ 18 * (fontWidth @ rowHeight);
		windowIcon: self class icon;
		aboutText: self class descriptionText
]

{ #category : #accessing }
RTBasicEditorPresenter >> isRuleForMethod [

	^ isMethodCheckbox state
]

{ #category : #accessing }
RTBasicEditorPresenter >> lhs [
	^ searchForEditor lhs
]

{ #category : #accessing }
RTBasicEditorPresenter >> lhs: aCode [
	searchForEditor lhs: aCode
]

{ #category : #accessing }
RTBasicEditorPresenter >> loadedRule: aRule [

	loadedRule := aRule
]

{ #category : #accessing }
RTBasicEditorPresenter >> rhs [
	^ replaceWithEditor rhs
]

{ #category : #accessing }
RTBasicEditorPresenter >> rhs: aCode [
	replaceWithEditor rhs: aCode
]
