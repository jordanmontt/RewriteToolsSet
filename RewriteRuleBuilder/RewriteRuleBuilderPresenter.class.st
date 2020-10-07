"
I am a tool for creating rewrite rules without knowing rewrite rule engine syntax. You can paste Pharo code and then abstract it to convert it to the pattern code of the Rewrite Rules.

To run me: `RewriteRuleBuilderPresenter open` or `RewriteRuleBuilderPresenter withCode: aCode`.
  

- resultPanel: holds result of applying rewrite rule to source code; not editable

- sourcePanel: holds source code of expression that has to be transformet into new one; editable

- transformationRule: `TransformationRulePresenter` holds the Rewrite Rule. There, you can select the part of the code 	that you want to abstract, right-click and it will convert the Pharo's code into pattern's code.
"
Class {
	#name : #RewriteRuleBuilderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'transformationRule',
		'sourcePanel',
		'resultPanel',
		'statusBarForResult',
		'statusBarForMatch',
		'ruleName',
		'undoButton',
		'redoButton',
		'saveRuleButton',
		'loadButton',
		'matchRuleButton',
		'basicEditorButton',
		'buttonsBar',
		'applyOnAllClassesButton',
		'applierButton'
	],
	#category : #'RewriteRuleBuilder-Core'
}

{ #category : #specs }
RewriteRuleBuilderPresenter class >> defaultSpec [

	| sourcePanel resultPanel codePanels |
	sourcePanel := SpBoxLayout newVertical
		               add: #sourcePanel;
		               add: #statusBarForMatch height: 40;
		               yourself.
	resultPanel := SpBoxLayout newVertical
		               add: #resultPanel;
		               add: #statusBarForResult height: 40;
		               yourself.
	codePanels := SpPanedLayout newHorizontal
		              add: sourcePanel;
		              add: resultPanel;
		              yourself.
	^ SpBoxLayout newVertical
		  add: (SpPanedLayout newVertical
				   add: codePanels;
				   add: #transformationRule;
				   yourself);
		  addLast: #buttonsBar;
		  yourself
]

{ #category : #accessing }
RewriteRuleBuilderPresenter class >> descriptionText [

	^ 'Build a rule abstracting Pharo''s code into pattern''s code without knowing the Rewrite Rule syntax'
]

{ #category : #accessing }
RewriteRuleBuilderPresenter class >> icon [

	^ self iconNamed: #scriptManager
]

{ #category : #'world menu' }
RewriteRuleBuilderPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'RewriteRuleBuilder')
		parent: #Tools;
		action: [ self open ];
		order: 31;
		icon: self icon;
		help: self descriptionText
]

{ #category : #'instance creation' }
RewriteRuleBuilderPresenter class >> open [

	^ self new openWithSpec
]

{ #category : #accessing }
RewriteRuleBuilderPresenter class >> title [

	^ 'Rewrite Rule Builder'
]

{ #category : #'instance creation' }
RewriteRuleBuilderPresenter class >> withCode: aString [

	| builder |
	builder := self new code: aString.
	^ builder openWithSpec
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> applyOnAllClasses [

	| rewriter rule |
	(UIManager default confirm:
		 'Do you want to apply this rule to all system classes?') ifFalse: [ 
		^ self ].
	rewriter := RBParseTreeRewriter new
		            replace: self lhs with: self rhs;
		            yourself.
	rule := RBTransformationRule new
		        rewriteRule: rewriter;
		        yourself.
	RewriteRuleApplierPresenter runReplaceOnAllClasses: rule
]

{ #category : #'api - initialization' }
RewriteRuleBuilderPresenter >> code: aString [

	sourcePanel code: aString.
	transformationRule lhs: aString.
	transformationRule rhs: aString.
	resultPanel code: aString
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> connectPresenters [

	matchRuleButton action: [ self openMatchTool ].
	saveRuleButton action: [ self saveRule ].
	undoButton action: [ self undo ].
	redoButton action: [ self redo ].
	loadButton action: [ self openLoader ].
	basicEditorButton action: [ self openBasicRuleEditor ].
	applyOnAllClassesButton action: [ self applyOnAllClasses ].
	applierButton action: [ self openApplier ].
	sourcePanel codePresenter
		whenSubmitDo: [ :aText | self sourcePanelChanged: aText ];
		whenTextChangedDo: [ :text | self updateUndoAndRedoButtonStatus ].
	transformationRule matchPanel codePresenter whenTextChangedDo: [ 
		:text | self updateUndoAndRedoButtonStatus ].
	transformationRule transformPanel codePresenter whenTextChangedDo: [ 
		:text | self updateUndoAndRedoButtonStatus ]
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> createStatusBarMatchMorph [

	^ (ActivePolygonMorph createArrowMorph: ActivePolygonMorph)
		  rotationDegrees: 90;
		  color: self matchColor;
		  infoText: self matchLabel;
		  yourself
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> createStatusBarResultMorph [

	^ (ActivePolygonMorph createArrowMorph: ActivePolygonMorph)
		  rotationDegrees: -90;
		  infoText: 'Result of applying rule to source code';
		  yourself
]

{ #category : #defaults }
RewriteRuleBuilderPresenter >> getRewriterFromCodePanels [

	^ RBParseTreeRewriter new
		  replace: transformationRule lhs
		  with: transformationRule rhs
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> initializePresenters [

	sourcePanel := self instantiate: SourcePanelPresenter.
	resultPanel := self instantiate: ResultPanelPresenter.
	transformationRule := self instantiate: TransformationRulePresenter.
	statusBarForMatch := self newMorph
		                     morph: self createStatusBarMatchMorph;
		                     yourself.
	statusBarForResult := self newMorph
		                      morph: self createStatusBarResultMorph;
		                      yourself.
	undoButton := self newButton
		              label: 'Undo';
		              icon: (self iconNamed: #smallUndo);
		              disable;
		              yourself.
	redoButton := self newButton
		              label: 'Redo';
		              icon: (self iconNamed: #smallRedo);
		              disable;
		              yourself.
	saveRuleButton := self newButton
		                  label: 'Save rule';
		                  icon: (self iconNamed: #smallSaveAs).
	loadButton := self newButton
		              label: 'Load a rule';
		              icon: RewriteRuleLoaderPresenter icon.
	matchRuleButton := self newButton
		                   label: 'Match rule';
		                   icon: MatchToolPresenter icon.
	basicEditorButton := self newButton
		                     label: 'Basic Editor';
		                     icon: RewriteBasicEditorPresenter icon.
	applyOnAllClassesButton := self newButton
		                           label: 'Apply rule';
		                           icon: RewriteRuleApplierPresenter icon.
	applierButton := self newButton
		                 label: 'Open Applier';
		                 icon: RewriteRuleApplierPresenter icon.
	buttonsBar := self newButtonBar
		              add: saveRuleButton;
		              add: applierButton;
		              add: applyOnAllClassesButton;
		              add: matchRuleButton;
		              add: basicEditorButton;
		              add: loadButton;
		              add: undoButton;
		              add: redoButton;
		              yourself.
	self
		lhs: DefaultBuilderRule new lhs;
		rhs: DefaultBuilderRule new rhs;
		inputCode: DefaultBuilderRule new inputCode;
		outputCode: DefaultBuilderRule new outputCode.
	self focusOrder
		add: sourcePanel;
		add: resultPanel;
		add: transformationRule;
		add: buttonsBar
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 820 @ 650;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #'api - accessing' }
RewriteRuleBuilderPresenter >> inputCode [

	^ sourcePanel text
]

{ #category : #'api - initialization' }
RewriteRuleBuilderPresenter >> inputCode: aString [

	sourcePanel code: aString
]

{ #category : #testing }
RewriteRuleBuilderPresenter >> isMatching [

	| rewriter |
	rewriter := self getRewriterFromCodePanels.
	(self lhs isEmpty and: [ self rhs isEmpty ]) ifTrue: [ ^ true ].
	^ [ rewriter executeTree: sourcePanel ast ]
		  on: Exception
		  do: [ :exception | false ]
]

{ #category : #'api - accessing' }
RewriteRuleBuilderPresenter >> lhs [

	^ transformationRule lhs
]

{ #category : #'api - initialization' }
RewriteRuleBuilderPresenter >> lhs: aString [

	transformationRule lhs: aString
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> matchColor [
	^ self isMatching
		ifTrue: [ Color green ]
		ifFalse: [ Color red ]
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> matchLabel [
	^ self isMatching
		ifTrue: [ 'Input AST matches LHS of rule.' ]
		ifFalse: [ 'Input AST does not match LHS of rule.' ]
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> openApplier [

	^ RewriteRuleApplierPresenter open
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> openBasicRuleEditor [

	^ RewriteBasicEditorPresenter new
		  replaceWithPatternCode: self rhs;
		  searchForPatternCode: self lhs;
		  openWithSpec
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> openLoader [

	^ RewriteRuleLoaderPresenter open
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> openMatchTool [

	^ MatchToolPresenter new
		  patternCode: self lhs;
		  pharoCode: self inputCode;
		  openWithSpec
]

{ #category : #'api - accessing' }
RewriteRuleBuilderPresenter >> outputCode [

	^ resultPanel text
]

{ #category : #'api - initialization' }
RewriteRuleBuilderPresenter >> outputCode: aString [

	resultPanel code: aString
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> redo [

	transformationRule redo
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> refreshStatusBar [

	statusBarForMatch color: self matchColor.
	statusBarForMatch morph infoText: self matchLabel
]

{ #category : #'api - accessing' }
RewriteRuleBuilderPresenter >> rhs [

	^ transformationRule rhs
]

{ #category : #'api - initialization' }
RewriteRuleBuilderPresenter >> rhs: aString [

	transformationRule rhs: aString
]

{ #category : #'api - initialization' }
RewriteRuleBuilderPresenter >> ruleName: aRuleName [

	ruleName := aRuleName
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> saveRule [

	^ CustomRuleGenerator new
		  searchFor: self lhs;
		  replaceWith: self rhs;
		  inputCode: self inputCode;
		  outputCode: self outputCode;
		  storeRule: ruleName
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> sourcePanel [
	^ sourcePanel
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> sourcePanelChanged: aText [

	transformationRule addPanelToUndoDict: sourcePanel.
	sourcePanel ast: (sourcePanel parse: aText).
	self refreshStatusBar
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> transformationRule [
	^ transformationRule
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> undo [

	transformationRule undo
]

{ #category : #api }
RewriteRuleBuilderPresenter >> updateResultPanelAst [

	| rewriter doesRewriterMatchSourceCode |
	rewriter := self getRewriterFromCodePanels.
	doesRewriterMatchSourceCode := [ 
	                               rewriter executeTree: sourcePanel ast ]
		                               on: Exception
		                               do: [ :exception | false ].
	doesRewriterMatchSourceCode ifTrue: [ resultPanel ast: rewriter tree ]
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> updateUndoAndRedoButtonStatus [

	transformationRule isUndoDictEmpty
		ifTrue: [ undoButton disable ]
		ifFalse: [ undoButton enable ].
	transformationRule isRedoDictEmpty
		ifTrue: [ redoButton disable ]
		ifFalse: [ redoButton enable ]
]
