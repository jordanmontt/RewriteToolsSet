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
		'sourcePanel',
		'resultPanel',
		'undoButton',
		'redoButton',
		'saveRuleButton',
		'loadButton',
		'matchRuleButton',
		'basicEditorButton',
		'buttonsBar',
		'applyOnAllClassesButton',
		'applierButton',
		'statusBarMorphForResult',
		'statusBarMorphForMatch',
		'loadedRule',
		'transformationRulePresenter'
	],
	#category : #'RewriteRuleBuilder-Main presenters'
}

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
		order: 33;
		icon: self icon;
		help: self descriptionText.
	aBuilder withSeparatorAfter
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

	| rule |
	(UIManager default confirm:
		 'Do you want to apply this rule to all system classes?') ifFalse: [ 
		^ self ].
	rule := RewriteCustomRuleGenerator new
		        searchFor: self lhs;
		        replaceWith: self rhs;
		        getInstanceRule.
	RewriteRuleApplierPresenter runReplaceOnAllClasses: rule
]

{ #category : #'api - initialization' }
RewriteRuleBuilderPresenter >> code: aString [

	sourcePanel code: aString.
	transformationRulePresenter lhs: aString.
	transformationRulePresenter rhs: aString.
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
	transformationRulePresenter matchPanel codePresenter whenTextChangedDo: [ 
		:text | self updateUndoAndRedoButtonStatus ].
	transformationRulePresenter transformPanel codePresenter whenTextChangedDo: [ 
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
		  replace: transformationRulePresenter lhs
		  with: transformationRulePresenter rhs
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> initializeLayout [

	| panels arrows |
	panels := SpBoxLayout newHorizontal
		          add: #sourcePanel;
		          add: #resultPanel;
		          yourself.
	arrows := SpBoxLayout newHorizontal
		          add: SpNullPresenter new;
		          add: SpNullPresenter new;
		          add: #statusBarMorphForMatch;
		          add: SpNullPresenter new;
		          add: SpNullPresenter new;
		          add: SpNullPresenter new;
		          add: SpNullPresenter new;
		          add: #statusBarMorphForResult;
		          add: SpNullPresenter new;
		          add: SpNullPresenter new;
		          yourself.
	self layout: (SpBoxLayout newVertical
			 add: panels;
			 add: arrows height: 40;
			 add: #transformationRulePresenter;
			 addLast: #buttonsBar;
			 yourself)
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> initializePresenters [

	self initializeLayout.
	sourcePanel := self instantiate: SourcePanelPresenter.
	resultPanel := self instantiate: ResultPanelPresenter.
	transformationRulePresenter := self instantiate:
		                               TransformationRulePresenter.
	statusBarMorphForMatch := self newMorph
		                          morph: self createStatusBarMatchMorph;
		                          yourself.
	statusBarMorphForResult := self newMorph
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
		                           label: 'On all classes';
		                           help:
			                           'Apply the current rewrite rule that is on this tool to all classes in the system.';
		                           icon: RewriteRuleApplierPresenter icon.
	applierButton := self newButton
		                 label: 'On selection...';
		                 help:
			                 'Open a tool to apply a saved rewrite rule to a selected set of classes.';
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
		add: transformationRulePresenter;
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

	^ transformationRulePresenter lhs
]

{ #category : #'api - initialization' }
RewriteRuleBuilderPresenter >> lhs: aString [

	transformationRulePresenter lhs: aString
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> loadedRule: aRule [

	loadedRule := aRule
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

	| applier |
	^ loadedRule
		  ifNotNil: [ 
			  applier := RewriteRuleApplierPresenter new.
			  applier rulesDropdown selectItem: loadedRule class.
			  applier openWithSpec ]
		  ifNil: [ RewriteRuleApplierPresenter open ]
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

	transformationRulePresenter redo
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> refreshStatusBar [

	statusBarMorphForMatch color: self matchColor.
	statusBarMorphForMatch morph infoText: self matchLabel
]

{ #category : #'api - accessing' }
RewriteRuleBuilderPresenter >> rhs [

	^ transformationRulePresenter rhs
]

{ #category : #'api - initialization' }
RewriteRuleBuilderPresenter >> rhs: aString [

	transformationRulePresenter rhs: aString
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> saveRule [

	^ RewriteCustomRuleGenerator new
		  searchFor: self lhs;
		  replaceWith: self rhs;
		  inputCode: self inputCode;
		  outputCode: self outputCode;
		  storeRule: loadedRule className
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> sourcePanel [
	^ sourcePanel
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> sourcePanelChanged: aText [

	transformationRulePresenter addPanelToUndoList: sourcePanel.
	sourcePanel ast: (sourcePanel parse: aText).
	self refreshStatusBar
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> transformationRule [
	^ transformationRulePresenter
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> undo [

	transformationRulePresenter undo
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

	transformationRulePresenter isUndoListEmpty
		ifTrue: [ undoButton disable ]
		ifFalse: [ undoButton enable ].
	transformationRulePresenter isRedoListEmpty
		ifTrue: [ redoButton disable ]
		ifFalse: [ redoButton enable ]
]
