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
		'undoDict',
		'redoDict',
		'transformationRuleLabel'
	],
	#category : #'RewriteRuleBuilder-Core'
}

{ #category : #specs }
TransformationRulePresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #transformationRuleLabel expand: false;
		  add: (SpPanedLayout newHorizontal
				   add: #matchPanel;
				   add: #transformPanel;
				   yourself);
		  yourself
]

{ #category : #undoRedo }
TransformationRulePresenter >> addAstToLastOfUndoDict: anAst [

	undoDict last ast add: anAst
]

{ #category : #undoRedo }
TransformationRulePresenter >> addChangeToRedoDict: aChange [

	redoDict add: (RewriteRuleChangesKeeper
			 panel: aChange panel
			 ast:
			 (aChange panel collect: [ :aPanel | aPanel ast ]))
]

{ #category : #undoRedo }
TransformationRulePresenter >> addChangeToUndoDict: aChange [

	undoDict add: (RewriteRuleChangesKeeper
			 panel: aChange panel
			 ast:
			 (aChange panel collect: [ :aPanel | aPanel ast ])
				 asOrderedCollection)
]

{ #category : #undoRedo }
TransformationRulePresenter >> addPanelToLastOfUndoDict: aPanel [

	undoDict last panel add: aPanel
]

{ #category : #undoRedo }
TransformationRulePresenter >> addPanelToUndoDict: aPanel [

	undoDict add: (RewriteRuleChangesKeeper
			 panel: aPanel asOrderedCollection
			 ast: aPanel ast asOrderedCollection)
]

{ #category : #undoRedo }
TransformationRulePresenter >> addToUndoDict: anObject [

	undoDict add: anObject
]

{ #category : #initialization }
TransformationRulePresenter >> connectPresenters [

	matchPanel codePresenter whenSubmitDo: [ :text | 
		self matchPanelChanged: text ].
	transformPanel codePresenter whenSubmitDo: [ :text | 
		self transformPanelChanged: text ]
]

{ #category : #initialization }
TransformationRulePresenter >> getTransformationRuleMorph [

	| morph font |
	font := LogicalFont
		        familyName: StandardFonts defaultFont familyName
		        pointSize: 20.
	morph := StringMorph
		         contents:
		         'Transformation Rule:            LHS        --->        RHS'
		         font: font.
	^ self newMorph
		  morph: morph;
		  yourself
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
	transformationRuleLabel := self getTransformationRuleMorph.
	self whenBuiltDo: [ 
		self adapter widget
			borderWidth: 5;
			borderColor: Color gray ].
	self focusOrder
		add: matchPanel;
		add: transformPanel
]

{ #category : #testing }
TransformationRulePresenter >> isRedoDictEmpty [

	^ redoDict isEmpty
]

{ #category : #testing }
TransformationRulePresenter >> isUndoDictEmpty [
	^ undoDict isEmpty
]

{ #category : #'api - accessing' }
TransformationRulePresenter >> lhs [

	^ matchPanel text
]

{ #category : #'api - accessing' }
TransformationRulePresenter >> lhs: aString [
 
	matchPanel code: aString
]

{ #category : #accessing }
TransformationRulePresenter >> matchPanel [
	^ matchPanel
]

{ #category : #actions }
TransformationRulePresenter >> matchPanelChanged: aText [

	self addPanelToUndoDict: matchPanel.
	matchPanel ast: (matchPanel parse: aText).
	self owner refreshStatusBar
]

{ #category : #undoRedo }
TransformationRulePresenter >> redo [

	| change |
	change := redoDict removeLast.
	self addChangeToUndoDict: change.
	1 to: change panel size do: [ :index | 
		| currentPanel selectedNode |
		currentPanel := change panel at: index.
		selectedNode := currentPanel getSelectedNode.
		selectedNode ifNotNil: [ 
			selectedNode oldNodes ifNotEmpty: [ 
				currentPanel codePresenter sourceTextArea widget 
					selectionInterval: selectedNode oldNodes last sourceInterval ] ].
		currentPanel ast:
			(currentPanel parse: (change ast at: index) formattedCode) ].
	self owner refreshStatusBar
]

{ #category : #'api - accessing' }
TransformationRulePresenter >> rhs [

	^ transformPanel text
]

{ #category : #'api - accessing' }
TransformationRulePresenter >> rhs: aString [

	transformPanel code: aString
]

{ #category : #accessing }
TransformationRulePresenter >> transformPanel [
	^ transformPanel
]

{ #category : #actions }
TransformationRulePresenter >> transformPanelChanged: aText [

	self addPanelToUndoDict: transformPanel.
	transformPanel ast: (transformPanel parse: aText).
	self owner updateResultPanelAst
]

{ #category : #undoRedo }
TransformationRulePresenter >> undo [

	| change |
	change := undoDict removeLast.
	self addChangeToRedoDict: change.
	1 to: change panel size do: [ :index | 
		| currentPanel selectedNode |
		currentPanel := change panel at: index.
		selectedNode := currentPanel getSelectedNode.
		selectedNode ifNotNil: [ 
			selectedNode oldNodes ifNotEmpty: [ 
				currentPanel codePresenter selectionInterval:
					selectedNode oldNodes last sourceInterval ] ].
		currentPanel ast:
			(currentPanel parse: (change ast at: index) formattedCode) ].
	self owner refreshStatusBar
]
