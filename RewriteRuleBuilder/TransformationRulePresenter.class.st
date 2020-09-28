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
		'undoDict',
		'redoDict',
		'statusBarForRule',
		'loadButton',
		'saveRuleButton',
		'transformationRuleLabel',
		'matchRuleButton',
		'basicEditorButton'
	],
	#category : #'RewriteRuleBuilder-Core'
}

{ #category : #specs }
TransformationRulePresenter class >> defaultSpec [

	| buttonsPanel |
	buttonsPanel := SpBoxLayout newVertical
		                add: #saveRuleButton;
		                add: #statusBarForRule;
		                add: #undoButton;
		                add: #redoButton;
		                add: #loadButton;
		                add: #matchRuleButton;
		                add: #basicEditorButton;
		                yourself.
	^ SpBoxLayout newVertical
		  add: #transformationRuleLabel expand: false;
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
			 ast: aPanel ast asOrderedCollection)
]

{ #category : #initialization }
TransformationRulePresenter >> connectPresenters [

	undoButton action: [ self undo ].
	redoButton action: [ self redo ].
	loadButton action: [ self openLoader ].
	basicEditorButton action: [ self openBasicRuleEditor ].
	matchPanel codePresenter whenSubmitDo: [ :text | 
		self matchPanelChanged: text ].
	transformPanel codePresenter whenSubmitDo: [ :text | 
		self transformPanelChanged: text ]
]

{ #category : #morphic }
TransformationRulePresenter >> getStatusBaMorph [

	| morph |
	morph := ActivePolygonMorph createArrowMorph: PolygonMorph.
	^ self newMorph
		  morph: morph;
		  yourself
]

{ #category : #morphic }
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
	undoDict := OrderedCollection new.
	redoDict := OrderedCollection new
]

{ #category : #initialization }
TransformationRulePresenter >> initializePresenters [

	matchPanel := self instantiate: MatchPanelPresenter.
	transformPanel := self instantiate: TransformPanelPresenter.
	statusBarForRule := self getStatusBaMorph.
	transformationRuleLabel := self getTransformationRuleMorph.
	undoButton := self newButton
		              label: 'Undo';
		              disable;
		              yourself.
	redoButton := self newButton
		              label: 'Redo';
		              disable;
		              yourself.
	saveRuleButton := self newButton
		                  label: 'Save rule';
		                  icon: (self iconNamed: #smallSave).
	loadButton := self newButton
		              label: 'Rule Loader';
		              icon: RewriteRuleLoaderPresenter icon.
	matchRuleButton := self newButton
		                   label: 'Match Tool';
		                   icon: MatchToolPresenter icon.
	basicEditorButton := self newButton
		                     label: 'Basic Editor';
		                     icon: RewriteBasicEditorPresenter icon.
	self whenBuiltDo: [ 
		self adapter widget
			borderWidth: 5;
			borderColor: Color gray ].
	self focusOrder
		add: saveRuleButton;
		add: undoButton;
		add: redoButton;
		add: loadButton;
		add: matchRuleButton;
		add: basicEditorButton
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

	self addChangeForPanel: matchPanel.
	undoButton enable.
	matchPanel ast: (matchPanel parse: aText).
	self owner matchSourcePanelCode
]

{ #category : #'api - accessing' }
TransformationRulePresenter >> matchToolButtonAction: aBlock [

	matchRuleButton action: aBlock
]

{ #category : #actions }
TransformationRulePresenter >> openBasicRuleEditor [

	^ RewriteBasicEditorPresenter new
		  replaceWithPatternCode: self rhs;
		  searchForPatternCode: self lhs;
		  openWithSpec
]

{ #category : #actions }
TransformationRulePresenter >> openLoader [

	^ RewriteRuleLoaderPresenter open
]

{ #category : #actions }
TransformationRulePresenter >> redo [

	| change |
	change := redoDict removeLast.
	self updateUndoDictFor: change.
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

{ #category : #'api - accessing' }
TransformationRulePresenter >> rhs [

	^ transformPanel text
]

{ #category : #'api - accessing' }
TransformationRulePresenter >> rhs: aString [

	transformPanel code: aString
]

{ #category : #actions }
TransformationRulePresenter >> saveRule [

	Halt now.
	CustomRuleGenerator new
		replaceWith: transformPanel text;
		searchFor: matchPanel text
]

{ #category : #'api - accessing' }
TransformationRulePresenter >> saveRuleButtonAction: aBlock [

	saveRuleButton action: aBlock
]

{ #category : #accessing }
TransformationRulePresenter >> transformPanel [
	^ transformPanel
]

{ #category : #actions }
TransformationRulePresenter >> transformPanelChanged: aText [

	self addChangeForPanel: transformPanel.
	undoButton enable.
	transformPanel ast: (transformPanel parse: aText).
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
		selectedNode := currentPanel getSelectedNode.
		selectedNode ifNotNil: [ 
			selectedNode oldNodes ifNotEmpty: [ 
				currentPanel codePresenter selectionInterval:
					selectedNode oldNodes last sourceInterval ] ].
		currentPanel ast:
			(currentPanel parse: (change ast at: index) formattedCode) ].
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
			 ast:
			 (aChange panel collect: [ :aPanel | aPanel ast ])
				 asOrderedCollection)
]

{ #category : #updating }
TransformationRulePresenter >> updateUndoDictFor: aChange [

	undoDict add: (RewriteRuleChangesKeeper
			 panel: aChange panel
			 ast:
			 (aChange panel collect: [ :aPanel | aPanel ast ])
				 asOrderedCollection)
]
