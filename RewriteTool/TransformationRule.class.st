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
	#superclass : #ComposableModel,
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
		'packageName'
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
	<spec>
	^ SpecLayout composed
		add: #ruleLabel
			top: 0.0
			bottom: 0.9
			left: 0.0
			right: 0.0;
		add: #matchPanel
			top: 0.1
			bottom: 0.0
			left: 0.0
			right: 0.58;
		add: #generateButton
			top: 0.1
			bottom: 0.72
			left: 0.42
			right: 0.42;
		add: #statusBarForRule
			top: 0.28
			bottom: 0.54
			left: 0.42
			right: 0.42;
		add: #undoButton
			top: 0.46
			bottom: 0.36
			left: 0.42
			right: 0.42;
		add: #redoButton
			top: 0.64
			bottom: 0.18
			left: 0.42
			right: 0.42;
		add: #browseButton
			top: 0.82
			bottom: 0.0
			left: 0.42
			right: 0.42;
		add: #transformPanel
			top: 0.1
			bottom: 0.0
			left: 0.58
			right: 0.0;
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
		category: packageName
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
TransformationRule >> initializePresenter [
	self undoButton action: [ self undo ].
	self redoButton action: [ self redo ].
	self generateButton action: [ self generateRewriteRuleClass ].
	self browseButton action: [ self browseRules ].
	self matchPanel textModel whenTextIsAccepted: [ self matchPanelChanged ].
	self transformPanel textModel whenTextIsAccepted: [ self transformPanelChanged ]
]

{ #category : #initialization }
TransformationRule >> initializeWidgets [
	self
		instantiateModels:
			#(#matchPanel #MatchPanel #transformPanel #TransformPanel #undoButton #ButtonModel #redoButton #ButtonModel #generateButton #ButtonModel #browseButton #ButtonModel).
	self undoButton
		label: 'Undo';
		disable.
	self redoButton
		label: 'Redo';
		disable.
	self generateButton label: 'Generate rule'.
	self browseButton label: 'Browse rules'.
	self
		whenBuiltDo: [ 
			self widget widget
				borderWidth: 5;
				borderColor: Color gray ].
	self focusOrder
		add: self generateButton;
		add: self undoButton;
		add: self browseButton;
		yourself
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

{ #category : #morphic }
TransformationRule >> ruleLabel [
	| morph |
	morph := StringMorph
		contents: 'Transformation Rule'
		font:
			(LogicalFont familyName: UITheme current labelFont familyName pointSize: UITheme current labelFont pointSize + 10).
	^ morph asSpecAdapter
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
	^ (TransformationRule arrowMorph: PolygonMorph) asSpecAdapter
		vSpaceFill;
		hSpaceFill;
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
	self owner statusBar widget infoText: self owner matchLabel.
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
	self owner statusBar widget infoText: self owner matchLabel
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
