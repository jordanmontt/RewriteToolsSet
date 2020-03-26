"
A TransformationRule is model that represents bottom part of RewriteRuleBuilder.

Instance Variables
	browseButton:		<ButtonModel>
	generateButton:		<ButtonModel>
	matchPanel:		<MatchPanel>
	transformPanel:		<TransformPanel>
	undoButton:		<ButtonModel>

browseButton
	- opens RewriteRuleBrowser

generateButton
	- generates class with current rule from match and transform panels

matchPanel
	- holds matching part of rewrite rule; editable

transformPanel
	- holds transforming part of rewrite rule; editable

undoButton
	- undo for three panels: match, transform and source

"
Class {
	#name : #TransformationRule,
	#superclass : #SpPresenter,
	#instVars : [
		'matchPanel',
		'transformPanel',
		'undoButton',
		'redoButton',
		'generateButton',
		'browseButton',
		'undoDict',
		'redoDict',
		'ruleName',
		'packageName',
		'statusBar',
		'presenterTitle'
	],
	#category : #'RewriteTool-Core'
}

{ #category : #morphic }
TransformationRule class >> arrowMorph: aClass [
	| morph |
	morph := aClass
		vertices:
			{(0 @ 80).
			(150 @ 80).
			(150 @ 25).
			(260 @ 100).
			(150 @ 175).
			(150 @ 120).
			(0 @ 120)}
		color: Color lightGray
		borderWidth: 5
		borderColor: Color black.
	morph scale: 0.25.
	^ morph
]

{ #category : #specs }
TransformationRule class >> defaultSpec [
	| buttonsPanel generalConstraints arrowConstrainsts |
	generalConstraints := [ :constra | constra padding: 4 ].
	arrowConstrainsts := [ :constra | constra padding: 4; height: 50 ].
	buttonsPanel := SpBoxLayout newVertical
		add: #generateButton withConstraints: generalConstraints;
		add: #statusBar withConstraints: arrowConstrainsts;
		add: #undoButton withConstraints: generalConstraints;
		add: #redoButton withConstraints: generalConstraints;
		add: #browseButton withConstraints: generalConstraints;
		borderWidth: 4;
		yourself.
	^ SpBoxLayout newVertical
		add: #presenterTitle height: 35;
		add:
			(SpBoxLayout newHorizontal
				add: #matchPanel;
				add: buttonsPanel width: 100;
				add: #transformPanel;
				yourself);
		yourself
]

{ #category : #actions }
TransformationRule >> addChangeForPanel: aPanel [
	self undoDict add: (RewriteRuleChange panel: aPanel asOrderedCollection ast: aPanel textModel ast asOrderedCollection)
]

{ #category : #accessing }
TransformationRule >> browseButton [
	^ browseButton
]

{ #category : #actions }
TransformationRule >> browseRules [
	| browser |
	browser := RewriteRuleBrowser new.
	browser openWithSpec
]

{ #category : #initialization }
TransformationRule >> connectPresenters [
	self undoButton action: [ self undo ].
	self redoButton action: [ self redo ].
	self generateButton action: [ self generateRewriteRuleClass ].
	self browseButton action: [ self browseRules ].
	self matchPanel textModel
		whenTextIsAcceptedDo: [ self matchPanelChanged ].
	self transformPanel textModel
		whenTextIsAcceptedDo: [ self transformPanelChanged ]
]

{ #category : #accessing }
TransformationRule >> generateButton [
	^ generateButton
]

{ #category : #actions }
TransformationRule >> generateRewriteRuleClass [
	ruleName := self inputClassName.
	(ruleName isNotNil and: [ ruleName ~= '' ])
		ifTrue: [ 
			| class |
			class := self generatedClassFor: ruleName.
			class compile: self getRuleInitString classified: 'initialization' ]
		ifFalse: [ self matchPanel classNotCreatedAlert ]
]

{ #category : #actions }
TransformationRule >> generatedClassFor: aClassName [
	packageName := self inputPackageName.
	^ RBCustomTransformationRule
		subclass: aClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: packageName
]

{ #category : #accessing }
TransformationRule >> getRuleInitString [
	^ 'initialize
	super initialize.
	self lhs: ''' , self matchPanel textModel text asString , '''.' , 'self rhs: '''
		, self transformPanel textModel text asString , '''.' , 'self input: ''' , self owner sourcePanel textModel text asString
		, '''.' , 'self output: ''' , self owner resultPanel textModel text asString , '''.'
		,
			'
	self rewriteRule
		replace: lhs
		with: rhs'
]

{ #category : #initialization }
TransformationRule >> initializePresenters [
	self initializeThePresenters.
	undoButton
		label: 'Undo';
		disable.
	redoButton
		label: 'Redo';
		disable.
	generateButton label: 'Generate rule'.
	browseButton label: 'Browse rules'.
	self
		whenBuiltDo: [ self adapter widget
				borderWidth: 5;
				borderColor: Color gray ].
	self focusOrder
		add: presenterTitle;
		add: statusBar;
		add: generateButton;
		add: undoButton;
		add: redoButton;
		add: browseButton
]

{ #category : #initialization }
TransformationRule >> initializeThePresenters [
	matchPanel := self instantiate: MatchPanel.
	transformPanel := self instantiate: TransformPanel.
	undoButton := self newButton.
	redoButton := self newButton.
	generateButton := self newButton.
	browseButton := self newButton.
	presenterTitle := self obtainPresenterTitle.
	"presenterTitle := self newLabel
		label: 'Transformation Rule';
		yourself."
	statusBar := self statusBarForRule
]

{ #category : #actions }
TransformationRule >> inputClassName [
	^ UIManager default request: 'Enter name for rewrite rule class: ' initialAnswer: ruleName
]

{ #category : #actions }
TransformationRule >> inputPackageName [
	^ UIManager default request: 'Enter name for rewrite rule package: ' initialAnswer: packageName
]

{ #category : #accessing }
TransformationRule >> matchPanel [
	^ matchPanel
]

{ #category : #actions }
TransformationRule >> matchPanelChanged [
	self addChangeForPanel: self matchPanel.
	self undoButton enable.
	self updateMatchPanel.
	self updateStatusBar.
	self transformPanel updateNextPanelForNode: nil
]

{ #category : #morphic }
TransformationRule >> obtainPresenterTitle [
	| morph |
	morph := StringMorph
		contents: 'Transformation Rule'
		font:
			(LogicalFont
				familyName: Smalltalk ui theme labelFont familyName
				pointSize: Smalltalk ui theme labelFont pointSize + 10).
	morph
		position: 270 @ 0.
	^ SpMorphPresenter new
		morph: (PanelMorph new addMorphFront: morph);
		yourself
]

{ #category : #accessing }
TransformationRule >> packageName [
	^ packageName
]

{ #category : #accessing }
TransformationRule >> packageName: anObject [
	packageName := anObject
]

{ #category : #actions }
TransformationRule >> redo [
	| change |
	change := self redoDict removeLast.
	self updateUndoDictFor: change.
	1 to: change panel size do: [ :index | 
		| currentPanel selectedNode |
		currentPanel := change panel at: index.
		selectedNode := currentPanel textModel getSelectedNode.
		selectedNode
			ifNotNil: [ 
				selectedNode oldNodes
					ifNotEmpty: [ currentPanel textModel sourceTextArea widget selectionInterval: selectedNode oldNodes last sourceInterval ] ].
		currentPanel textModel ast: (currentPanel parse: (change ast at: index) formattedCode).
		currentPanel textModel text: currentPanel textModel ast formattedCode ].
	self updateAfterUndoOrRedo
]

{ #category : #accessing }
TransformationRule >> redoButton [
	^ redoButton
]

{ #category : #accessing }
TransformationRule >> redoDict [
	^ redoDict ifNil: [ redoDict := OrderedCollection new ]
]

{ #category : #accessing }
TransformationRule >> ruleName [
	^ ruleName
]

{ #category : #accessing }
TransformationRule >> ruleName: aName [
	ruleName := aName
]

{ #category : #morphic }
TransformationRule >> statusBarForRule [
	| morph |
	morph := TransformationRule arrowMorph: PolygonMorph.
	morph
		vResizing: #spaceFill;
		hResizing: #spaceFil;
		scale: 0.01.
	^ SpMorphPresenter new
		morph: morph;
		yourself
]

{ #category : #accessing }
TransformationRule >> transformPanel [
	^ transformPanel
]

{ #category : #actions }
TransformationRule >> transformPanelChanged [
	self addChangeForPanel: self transformPanel.
	self undoButton enable.
	self transformPanel textModel
		ast: (self transformPanel parse: self transformPanel textModel text);
		text: self transformPanel textModel ast formattedCode;
		yourself.
	self transformPanel updateNextPanelForNode: nil
]

{ #category : #actions }
TransformationRule >> undo [
	| change |
	change := self undoDict removeLast.
	self updateRedoDictFor: change.
	1 to: change panel size do: [ :index | 
		| currentPanel selectedNode |
		currentPanel := change panel at: index.
		selectedNode := currentPanel textModel getSelectedNode.
		selectedNode
			ifNotNil: [ 
				selectedNode oldNodes
					ifNotEmpty: [ currentPanel textModel sourceTextArea widget selectionInterval: selectedNode oldNodes last sourceInterval ] ].
		currentPanel textModel ast: (currentPanel parse: (change ast at: index) formattedCode).
		currentPanel textModel text: currentPanel textModel ast formattedCode ].
	self updateAfterUndoOrRedo
]

{ #category : #accessing }
TransformationRule >> undoButton [
	^ undoButton
]

{ #category : #accessing }
TransformationRule >> undoDict [
	^ undoDict ifNil: [ undoDict := OrderedCollection new ]
]

{ #category : #updating }
TransformationRule >> updateAfterUndoOrRedo [
	self undoDict ifEmpty: [ self undoButton disable ] ifNotEmpty: [ self undoButton enable ].
	self redoDict ifEmpty: [ self redoButton disable ] ifNotEmpty: [ self redoButton enable ].
	self owner statusBar color: self owner matchColor.
	self owner statusBar morph infoText: self owner matchLabel.
	self transformPanel updateNextPanelForNode: nil
]

{ #category : #updating }
TransformationRule >> updateMatchPanel [
	self matchPanel textModel
		ast: (self matchPanel parse: self matchPanel textModel text);
		text: self matchPanel textModel ast formattedCode;
		yourself
]

{ #category : #updating }
TransformationRule >> updateRedoDictFor: aChange [
	self redoDict
		add:
			(RewriteRuleChange panel: aChange panel ast: (aChange panel collect: [ :each | each textModel ast ]) asOrderedCollection)
]

{ #category : #updating }
TransformationRule >> updateStatusBar [
	self owner statusBar color: self owner matchColor.
	self owner statusBar morph infoText: self owner matchLabel
]

{ #category : #updating }
TransformationRule >> updateUndoDictFor: aChange [
	self undoDict
		add:
			(RewriteRuleChange new
				panel: aChange panel;
				ast: (aChange panel collect: [ :each | each textModel ast ]) asOrderedCollection;
				yourself)
]
