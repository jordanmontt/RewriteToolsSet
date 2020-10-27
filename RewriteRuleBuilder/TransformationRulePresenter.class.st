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
		'transformationRuleLabel',
		'undoList',
		'redoList'
	],
	#category : #'RewriteRuleBuilder-Main presenters'
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
TransformationRulePresenter >> addAstToLastElementOfUndoList: anAst [

	undoList last ast add: anAst
]

{ #category : #undoRedo }
TransformationRulePresenter >> addChangeToRedoList: aChange [

	redoList add: (RewriteRuleChangesKeeper
			 panel: aChange panel
			 ast:
			 (aChange panel collect: [ :aPanel | aPanel ast ]))
]

{ #category : #undoRedo }
TransformationRulePresenter >> addChangeToUndoList: aChange [

	undoList add: (RewriteRuleChangesKeeper
			 panel: aChange panel
			 ast:
			 (aChange panel collect: [ :aPanel | aPanel ast ])
				 asOrderedCollection)
]

{ #category : #undoRedo }
TransformationRulePresenter >> addPanelToLastElementOfUndoList: aPanel [

	undoList last panel add: aPanel
]

{ #category : #undoRedo }
TransformationRulePresenter >> addPanelToUndoList: aPanel [

	undoList add: (RewriteRuleChangesKeeper
			 panel: aPanel asOrderedCollection
			 ast: aPanel ast asOrderedCollection)
]

{ #category : #undoRedo }
TransformationRulePresenter >> addToUndoList: anObject [

	undoList add: anObject
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
	morph := StringMorph contents: 'Transformation Rule' font: font.
	^ self newMorph
		  morph: morph;
		  yourself
]

{ #category : #initialization }
TransformationRulePresenter >> initialize [

	super initialize.
	undoList := OrderedCollection new.
	redoList := OrderedCollection new
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
TransformationRulePresenter >> isRedoListEmpty [

	^ redoList isEmpty
]

{ #category : #testing }
TransformationRulePresenter >> isUndoListEmpty [
	^ undoList isEmpty
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

	self addPanelToUndoList: matchPanel.
	matchPanel ast: (matchPanel parse: aText).
	self owner refreshStatusBar
]

{ #category : #undoRedo }
TransformationRulePresenter >> redo [

	| change |
	change := redoList removeLast.
	self addChangeToUndoList: change.
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

	self addPanelToUndoList: transformPanel.
	transformPanel ast: (transformPanel parse: aText).
	self owner updateResultPanelAst
]

{ #category : #undoRedo }
TransformationRulePresenter >> undo [

	| change |
	change := undoList removeLast.
	self addChangeToRedoList: change.
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
