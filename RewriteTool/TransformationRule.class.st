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
		'undoButton',
		'redoButton',
		'generateButton',
		'browseButton',
		'undoDict',
		'redoDict',
		'ruleName',
		'packageName',
		'statusBar',
		'presenterTitle',
		'searchForPanel',
		'replaceWithPanel'
	],
	#category : #'RewriteTool-ExampleBasedTransformation'
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
	arrowConstrainsts := [ :constra | 
	constra
		padding: 4;
		height: 50 ].
	buttonsPanel := SpBoxLayout newVertical
		add: #generateButton withConstraints: generalConstraints;
		add: #statusBar withConstraints: arrowConstrainsts;
		add: #browseButton withConstraints: generalConstraints;
		borderWidth: 4;
		yourself.
	^ SpBoxLayout newVertical
		add: #presenterTitle height: 35;
		add:
			(SpBoxLayout newHorizontal
				add: #searchForPanel;
				add: buttonsPanel width: 100;
				add: #replaceWithPanel;
				yourself);
		yourself
]

{ #category : #'undo-redo' }
TransformationRule >> addChangeForPanel: aPanel [
	self
		deprecated:
			'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	self undoDict
		add:
			(RewriteRuleChange
				panel: aPanel asOrderedCollection
				ast: aPanel textModel ast asOrderedCollection)
]

{ #category : #accessing }
TransformationRule >> browseButton [
	^ browseButton
]

{ #category : #actions }
TransformationRule >> browseRules [
	| browser |
	browser := RewriteRuleBrowserPresenter new.
	browser openWithSpec
]

{ #category : #initialization }
TransformationRule >> connectPresenters [
	"undoButton action: [ self undo ].
	redoButton action: [ self redo ]."
	generateButton action: [ self generateRewriteRuleClass ].
	browseButton action: [ self browseRules ].
	self flag: #accessInnerLogicTextoModel.
	searchForPanel codePresenter
		whenTextIsAcceptedDo: [ self matchPanelChanged ].
	self flag: #accessInnerLogicTextoModel.
	replaceWithPanel codePresenter
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
		ifTrue: [ | class |
			class := self generatedClassFor: ruleName.
			class compile: self getRuleInitString classified: 'initialization' ]
		ifFalse: [ searchForPanel classNotCreatedAlert ].
	self flag: #searchPanelHasNoResponsibilityToCreateAnAlert
]

{ #category : #actions }
TransformationRule >> generatedClassFor: aClassName [
	packageName := self inputPackageProtocol.
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
	self lhs: ''' , searchForPanel codePresenter text asString
		, '''.' , 'self rhs: '''
		, replaceWithPanel codePresenter text asString , '''.'
		, 'self input: '''
		, self owner sourcePanel codePresenter text asString , '''.'
		, 'self output: '''
		, self owner resultPanel codePresenter text asString , '''.'
		,
			'
	self rewriteRule
		replace: lhs
		with: rhs'
]

{ #category : #initialization }
TransformationRule >> initializePresenters [
	searchForPanel := self instantiate: SearchForPanelPresenter.
	replaceWithPanel := self instantiate: ReplaceWithPanelPresenter.
	"undoButton := self newButton
		label: 'Undo';
		disable;
		yourself.
	redoButton := self newButton
		label: 'Redo';
		disable;
		yourself."
	generateButton := self newButton
		label: 'Generate rule';
		yourself.
	browseButton := self newButton
		label: 'Browse rules';
		yourself.
	"presenterTitle := self obtainPresenterTitle."
	presenterTitle := self newLabel
		label: 'Transformation Rule';
		yourself.
	statusBar := self statusBarForRule.
	self
		whenBuiltDo: [ self adapter widget
				borderWidth: 5;
				borderColor: Color gray ].
	self focusOrder
		add: presenterTitle;
		add: searchForPanel;
		add: replaceWithPanel;
		add: statusBar;
		add: generateButton;
		add: undoButton;
		add: redoButton;
		add: browseButton
]

{ #category : #actions }
TransformationRule >> inputClassName [
	^ UIManager default request: 'Enter name for rewrite rule class: ' initialAnswer: ruleName
]

{ #category : #actions }
TransformationRule >> inputPackageProtocol [
	^ UIManager default request: 'Enter name for rewrite rule package: ' initialAnswer: packageName
]

{ #category : #actions }
TransformationRule >> matchPanelChanged [
	"self addChangeForPanel: self searchForPanel."
	"self undoButton enable."
	self updateMatchPanel.
	self updateStatusBar.
	self replaceWithPanel updateNextPanelForNode: nil
]

{ #category : #morphic }
TransformationRule >> obtainPresenterTitle [
	| morph |
	morph := StringMorph
		contents: 'Transformation Rule'
		font:
			(LogicalFont
				familyName: self theme labelFont familyName
				pointSize: self theme labelFont pointSize + 10).
	morph position: 270 @ 0.
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

{ #category : #'undo-redo' }
TransformationRule >> redo [
	| change |
	self
		deprecated:
			'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	change := self redoDict removeLast.
	self updateUndoDictFor: change.
	1 to: change panel size do: [ :index | 
		| currentPanel selectedNode |
		currentPanel := change panel at: index.
		selectedNode := currentPanel textModel getSelectedNode.
		selectedNode
			ifNotNil: [ selectedNode oldNodes
					ifNotEmpty: [ currentPanel textModel sourceTextArea widget
							selectionInterval: selectedNode oldNodes last sourceInterval ] ].
		currentPanel textModel
			ast: (currentPanel parse: (change ast at: index) formattedCode).
		currentPanel textModel
			text: currentPanel textModel ast formattedCode ].
	self updateAfterUndoOrRedo
]

{ #category : #'undo-redo' }
TransformationRule >> redoButton [
	self
		deprecated:
			'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	^ redoButton
]

{ #category : #'undo-redo' }
TransformationRule >> redoDict [
	self
		deprecated:
			'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	^ redoDict ifNil: [ redoDict := OrderedCollection new ]
]

{ #category : #accessing }
TransformationRule >> replaceWithPanel [
	self flag: #instanceVariableShouldNotHaveAnAccessor.
	^ replaceWithPanel
]

{ #category : #accessing }
TransformationRule >> ruleName [
	^ ruleName
]

{ #category : #accessing }
TransformationRule >> ruleName: aName [
	ruleName := aName
]

{ #category : #accessing }
TransformationRule >> searchForPanel [
	^ searchForPanel
]

{ #category : #morphic }
TransformationRule >> statusBarForRule [
	| morph |
	morph := self class arrowMorph: PolygonMorph.
	morph
		vResizing: #spaceFill;
		hResizing: #spaceFil;
		scale: 0.01.
	^ SpMorphPresenter new
		morph: morph;
		yourself
]

{ #category : #actions }
TransformationRule >> transformPanelChanged [
	"self addChangeForPanel: self replaceWithPanel."

	"self undoButton enable."

	self flag: #accessInnerVariableTextModel.
	replaceWithPanel textModel
		ast: (self replaceWithPanel parse: self replaceWithPanel textModel text);
		text: self replaceWithPanel textModel ast formattedCode.
	replaceWithPanel updateNextPanelForNode: nil
]

{ #category : #'undo-redo' }
TransformationRule >> undo [
	"ifNotEmpty: [ currentPanel textModel sourceTextArea widget selectionInterval: selectedNode oldNodes last sourceInterval ] ]."

	| change |
	self
		deprecated:
			'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	change := self undoDict removeLast.
	self updateRedoDictFor: change.
	1 to: change panel size do: [ :index | 
		| currentPanel selectedNode |
		currentPanel := change panel at: index.
		selectedNode := currentPanel textModel getSelectedNode.
		selectedNode
			ifNotNil: [ selectedNode oldNodes
					ifNotEmpty: [ currentPanel textModel
							selectionInterval: selectedNode oldNodes last sourceInterval ] ].
		currentPanel textModel
			ast: (currentPanel parse: (change ast at: index) formattedCode).
		currentPanel textModel
			text: currentPanel textModel ast formattedCode ].
	self updateAfterUndoOrRedo
]

{ #category : #'undo-redo' }
TransformationRule >> undoButton [
	self deprecated: 'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	^ undoButton
]

{ #category : #'undo-redo' }
TransformationRule >> undoDict [
	self deprecated: 'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	^ undoDict ifNil: [ undoDict := OrderedCollection new ]
]

{ #category : #'undo-redo' }
TransformationRule >> updateAfterUndoOrRedo [
	self deprecated: 'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	self undoDict
		ifEmpty: [ self undoButton disable ]
		ifNotEmpty: [ self undoButton enable ].
	self redoDict
		ifEmpty: [ redoButton disable ]
		ifNotEmpty: [ redoButton enable ].
	self owner statusBar color: self owner matchColor.
	self owner statusBar morph infoText: self owner matchLabel.
	self replaceWithPanel updateNextPanelForNode: nil
]

{ #category : #updating }
TransformationRule >> updateMatchPanel [
	self searchForPanel codePresenter
		ast: (searchForPanel parse: searchForPanel codeSource);
		text: searchForPanel codePresenter ast formattedCode
]

{ #category : #'undo-redo' }
TransformationRule >> updateRedoDictFor: aChange [
	self deprecated: 'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	self redoDict
		add:
			(RewriteRuleChange
				panel: aChange panel
				ast:
					(aChange panel collect: [ :each | each textModel ast ])
						asOrderedCollection)
]

{ #category : #updating }
TransformationRule >> updateStatusBar [
	self owner statusBar color: self owner matchColor.
	self owner statusBar morph infoText: self owner matchLabel
]

{ #category : #'undo-redo' }
TransformationRule >> updateUndoDictFor: aChange [
	self deprecated: 'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	self undoDict
		add:
			(RewriteRuleChange new
				panel: aChange panel;
				ast:
					(aChange panel collect: [ :each | each textModel ast ])
						asOrderedCollection;
				yourself)
]
