"
I am a presenter for the Rewrite Rule. The panels represents the two part of the Rewrite Rule (lhs and rhs) the searchFor and replaceWith pattern code. I am a sub presenter of `RewriteRuleBuilderPresenter`.

You can select the code inside the matchPanel, right-click it and it will show a menu with several options to abstract the Pharo's code to pattern code. For example, if you select a Statement `OrderedCollection new`, right-click ti and select the option: ""Abstract statement"" it will be converted to `.@Statement1
 
- matchPanel: holds matching part of rewrite rule; editable

- transformPanel: holds transforming part of rewrite rule; editable

- undoButton: undo for three panels: match, transform and source

- redoButton: redo for three panels: match, transform and source
"
Class {
	#name : #TransformationRulePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'matchPanel',
		'transformPanel',
		'undoButton',
		'redoButton',
		'generateButton',
		'undoDict',
		'redoDict',
		'ruleLabel',
		'statusBarForRule',
		'loadButton'
	],
	#category : #'RewriteRuleBuilder-Core'
}

{ #category : #morphic }
TransformationRulePresenter class >> arrowMorph: aClass [

	| morph |
	morph := aClass
		         vertices: { 
				         (0 @ 80).
				         (150 @ 80).
				         (150 @ 25).
				         (260 @ 100).
				         (150 @ 175).
				         (150 @ 120).
				         (0 @ 120) }
		         color: Color lightGray
		         borderWidth: 5
		         borderColor: Color black.
	morph scale: 0.25.
	^ morph
]

{ #category : #specs }
TransformationRulePresenter class >> defaultSpec [

	| buttonsPanel |
	buttonsPanel := SpBoxLayout newVertical
		                add: #generateButton;
		                add: #statusBarForRule;
		                add: #undoButton;
		                add: #redoButton;
		                add: #loadButton;
		                borderWidth: 4;
		                yourself.
	^ SpBoxLayout newVertical
		  add: #ruleLabel expand: false;
		  add: (SpBoxLayout newHorizontal
				   add: #matchPanel;
				   add: buttonsPanel expand: false;
				   add: #transformPanel;
				   yourself);
		  yourself
]

{ #category : #actions }
TransformationRulePresenter >> addChangeForPanel: aPanel [

	undoDict add: (RewriteRuleChangesKeeper
			 panel: aPanel asOrderedCollection
			 ast: aPanel codePresenter ast asOrderedCollection)
]

{ #category : #initialization }
TransformationRulePresenter >> connectPresenters [

	undoButton action: [ self undo ].
	redoButton action: [ self redo ].
	generateButton action: [  ].
	loadButton action: [  ].
	matchPanel codePresenter whenSubmitDo: [ :text | 
		self matchPanelChanged: text ].
	transformPanel codePresenter whenSubmitDo: [ :text | 
		self transformPanelChanged: text ]
]

{ #category : #initialization }
TransformationRulePresenter >> initialize [

	super initialize.
	undoDict := OrderedCollection new.
	redoDict := OrderedCollection new
]

{ #category : #initialization }
TransformationRulePresenter >> initializePresenters [

	matchPanel := self instantiate: MatchPanelPresenter.
	transformPanel := self instantiate: TransformPanelPresenter.
	statusBarForRule := self statusBarForRule.
	ruleLabel := self ruleLabel.
	undoButton := self newButton
		              label: 'Undo';
		              disable;
		              yourself.
	redoButton := self newButton
		              label: 'Redo';
		              disable;
		              yourself.
	generateButton := self newButton label: 'Save rule'.
	loadButton := self newButton label: 'Load rules'.
	self whenBuiltDo: [ 
		self adapter widget
			borderWidth: 5;
			borderColor: Color gray ].
	self focusOrder
		add: generateButton;
		add: undoButton;
		add: redoButton;
		add: loadButton
]

{ #category : #accessing }
TransformationRulePresenter >> matchPanel [
	^ matchPanel
]

{ #category : #actions }
TransformationRulePresenter >> matchPanelChanged: aText [

	self addChangeForPanel: matchPanel.
	undoButton enable.
	matchPanel codePresenter ast: (matchPanel parse: aText).
	self owner matchSourcePanelCode
]

{ #category : #actions }
TransformationRulePresenter >> redo [

	| change |
	change := redoDict removeLast.
	self updateUndoDictFor: change.
	1 to: change panel size do: [ :index | 
		| currentPanel selectedNode |
		currentPanel := change panel at: index.
		selectedNode := currentPanel codePresenter getSelectedNode.
		selectedNode ifNotNil: [ 
			selectedNode oldNodes ifNotEmpty: [ 
				currentPanel codePresenter sourceTextArea widget selectionInterval:
					selectedNode oldNodes last sourceInterval ] ].
		currentPanel codePresenter ast:
			(currentPanel parse: (change ast at: index) formattedCode).
		currentPanel codePresenter text:
			currentPanel codePresenter ast formattedCode ].
	self updateAfterUndoOrRedo
]

{ #category : #accessing }
TransformationRulePresenter >> redoButton [
	^ redoButton
]

{ #category : #accessing }
TransformationRulePresenter >> redoDict [

	^ redoDict
]

{ #category : #morphic }
TransformationRulePresenter >> ruleLabel [

	| morph font |
	font := LogicalFont
		        familyName: StandardFonts defaultFont familyName
		        pointSize: 20.
	morph := StringMorph contents: 'Transformation Rule' font: font.
	^ SpMorphPresenter new
		  morph: morph;
		  yourself
]

{ #category : #morphic }
TransformationRulePresenter >> statusBarForRule [

	| morph |
	morph := (self class arrowMorph: PolygonMorph).
	^ SpMorphPresenter new
		  morph: morph;
		  yourself
]

{ #category : #accessing }
TransformationRulePresenter >> transformPanel [
	^ transformPanel
]

{ #category : #actions }
TransformationRulePresenter >> transformPanelChanged: aText [

	self addChangeForPanel: transformPanel.
	undoButton enable.
	transformPanel codePresenter ast: (transformPanel parse: aText).
	self owner updateResultPanelAst
]

{ #category : #actions }
TransformationRulePresenter >> undo [

	| change |
	change := undoDict removeLast.
	self updateRedoDictFor: change.
	1 to: change panel size do: [ :index | 
		| currentPanel selectedNode |
		currentPanel := change panel at: index.
		selectedNode := currentPanel codePresenter getSelectedNode.
		selectedNode ifNotNil: [ 
			selectedNode oldNodes ifNotEmpty: [ 
				currentPanel codePresenter selectionInterval:
					selectedNode oldNodes last sourceInterval ] ].
		currentPanel codePresenter ast:
			(currentPanel parse: (change ast at: index) formattedCode).
		currentPanel codePresenter text:
			currentPanel codePresenter ast formattedCode ].
	self updateAfterUndoOrRedo
]

{ #category : #accessing }
TransformationRulePresenter >> undoButton [
	^ undoButton
]

{ #category : #accessing }
TransformationRulePresenter >> undoDict [

	^ undoDict
]

{ #category : #updating }
TransformationRulePresenter >> updateAfterUndoOrRedo [

	undoDict
		ifEmpty: [ undoButton disable ]
		ifNotEmpty: [ undoButton enable ].
	redoDict
		ifEmpty: [ redoButton disable ]
		ifNotEmpty: [ redoButton enable ].
	self owner matchSourcePanelCode
]

{ #category : #updating }
TransformationRulePresenter >> updateRedoDictFor: aChange [

	redoDict add: (RewriteRuleChangesKeeper
			 panel: aChange panel
			 ast: (aChange panel collect: [ :each | each codePresenter ast ])
					 asOrderedCollection)
]

{ #category : #updating }
TransformationRulePresenter >> updateUndoDictFor: aChange [

	undoDict add: (RewriteRuleChangesKeeper
			 panel: aChange panel
			 ast: (aChange panel collect: [ :each | each codePresenter ast ])
					 asOrderedCollection)
]
