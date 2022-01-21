"
I am a tool that allows you to create, apply and save custom rewrite rules. To open me go to my class side method `open`.

You can write the rewrite rule on searchFor's and replaceWith's editors. When the rewrite rule is written, you can click on 'Open Applier' for open a tool that allows you to apply the rewrite rule to specific classes. Or you just can click on 'Apply on all classes' to apply the rewrite rule to all system's classes.

The Applier only works with saved rules, so remember to save your rule before open it. To apply the rule to all system's classes you do not need to save the rule.

The rule is saved as a subclass of `RBTransformationRule` so the name you enter must be a valid class name.

If you want to edit an already saved rewrite rule, just click on 'Open Loader' and select your rule. When you open me with an already saved rule and click the 'Save rule' button, the name of the rule is entered by default. If you save a rewrite rule with the same name it will be updated.

Click on MatchTool to open a tool that allows you to match your rule with a block of Pharo's code.
"
Class {
	#name : #RTRuleEditorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'cheatSheet',
		'saveButton',
		'loadButton',
		'expressionFinderButton',
		'matcherButton',
		'searchForEditor',
		'replaceWithEditor',
		'openApplierButton',
		'applyButton',
		'isMethodCheckbox',
		'applyToSelectedClassesButton',
		'scopeSelectorPresenter'
	],
	#category : #'RewriteRuleTools-RuleEditor'
}

{ #category : #accessing }
RTRuleEditorPresenter class >> descriptionText [ 

	^ 'A tool to build and apply custom Rewrite Rules.'
]

{ #category : #accessing }
RTRuleEditorPresenter class >> icon [

	^ self iconNamed: self iconName
]

{ #category : #accessing }
RTRuleEditorPresenter class >> iconName [
	^ #workspaceIcon
]

{ #category : #'world menu' }
RTRuleEditorPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'Rewrite Rule Editor')
		action: [ self open ];
		order: 30;
		parent: #Tools;
		help: self descriptionText;
		icon: self icon
]

{ #category : #specs }
RTRuleEditorPresenter class >> open [

	<example>
	^ RTApplication new startRuleEditor
]

{ #category : #specs }
RTRuleEditorPresenter class >> title [

	^ 'Rewrite Basic Editor'
]

{ #category : #initialization }
RTRuleEditorPresenter >> initializeButtons [

	loadButton := self instantiate: (OpenRTRuleLoaderCommand asSpecButtonForContext: self).
	saveButton := self instantiate: (SaveRuleCommand asSpecButtonForContext: self).
	openApplierButton := self instantiate: (OpenRTTransformerCommand asSpecButtonForContext: self).
	matcherButton := self instantiate: (OpenMatchToolCommand asSpecButtonForContext: self).
	applyButton := self instantiate: (ApplyRuleOnAllClassesCommand asSpecButtonForContext: self).
	expressionFinderButton := self instantiate:
		(OpenRTExpressionFinderCommand asSpecButtonForContext: self).
	applyToSelectedClassesButton :=self instantiate:
		(ApplyRuleOnSelectedClassesCommand asSpecButtonForContext: self)
]

{ #category : #initialization }
RTRuleEditorPresenter >> initializeLayout [

	| tempLayout|
	tempLayout := SpPanedLayout newLeftToRight
		add: (SpPanedLayout newVertical
			add: searchForEditor;
			add: replaceWithEditor;
			yourself);
		add: (SpBoxLayout newTopToBottom
			add: isMethodCheckbox expand: false;
			add: cheatSheet expand: true;
			add: applyButton expand: false;
			add: applyToSelectedClassesButton expand: false;
			add: expressionFinderButton expand: false;
			add: matcherButton expand: false;
			add: openApplierButton expand: false;
			add: saveButton expand: false;
			add: loadButton expand: false;
			yourself);
		positionOfSlider: 75 percent;
		yourself.
	self layout: (tempLayout)
]

{ #category : #initialization }
RTRuleEditorPresenter >> initializeMethodCheckbox [

	isMethodCheckbox := self newCheckBox.
	isMethodCheckbox label: 'The rule is for a method?'
]

{ #category : #initialization }
RTRuleEditorPresenter >> initializePresenters [

	self initializeMethodCheckbox.
	self initializeTextCheatSheet.
	self initializeRuleEditors.
	self initializeButtons.
	self initializeScopeSelectorPresenter.
	
	self initializeLayout
]

{ #category : #initialization }
RTRuleEditorPresenter >> initializeRuleEditors [

	searchForEditor := self instantiate: RTSearchForPanel.
	replaceWithEditor := self instantiate: RTReplaceWithPanel
]

{ #category : #initialization }
RTRuleEditorPresenter >> initializeScopeSelectorPresenter [

	scopeSelectorPresenter := self instantiate: ScopeSelectorPresenter
]

{ #category : #initialization }
RTRuleEditorPresenter >> initializeTextCheatSheet [

	cheatSheet := self instantiate: RTCheatSheetPresenter
]

{ #category : #initialization }
RTRuleEditorPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 700 @ 500;
		windowIcon: self class icon;
		aboutText: self class descriptionText
]

{ #category : #accessing }
RTRuleEditorPresenter >> isRuleForMethod [

	^ isMethodCheckbox state
]

{ #category : #accessing }
RTRuleEditorPresenter >> lhs [
	^ searchForEditor lhs
]

{ #category : #accessing }
RTRuleEditorPresenter >> lhs: aCode [
	searchForEditor lhs: aCode
]

{ #category : #accessing }
RTRuleEditorPresenter >> rhs [
	^ replaceWithEditor rhs
]

{ #category : #accessing }
RTRuleEditorPresenter >> rhs: aCode [
	replaceWithEditor rhs: aCode
]

{ #category : #accessing }
RTRuleEditorPresenter >> scopeSelectorPresenter [

	^ scopeSelectorPresenter
]
