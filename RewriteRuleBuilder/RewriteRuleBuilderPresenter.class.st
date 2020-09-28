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
		'statusBarForMatch'
	],
	#category : #'RewriteRuleBuilder-Core'
}

{ #category : #specs }
RewriteRuleBuilderPresenter class >> defaultSpec [

	| sourcePanel resultPanel |
	sourcePanel := SpBoxLayout newVertical
		               add: #sourcePanel;
		               add: #statusBarForMatch height: 40;
		               yourself.
	resultPanel := SpBoxLayout newVertical
		               add: #resultPanel;
		               add: #statusBarForResult height: 40;
		               yourself.
	^ SpBoxLayout newVertical
		  add: (SpBoxLayout newHorizontal
				   add: sourcePanel;
				   add: resultPanel;
				   yourself);
		  add: #transformationRule;
		  yourself
]

{ #category : #defaults }
RewriteRuleBuilderPresenter class >> helpText [

	^ 'Build a rule abstracting Pharo''s code into pattern''s code without knowing the Rewrite Rule syntax'
]

{ #category : #'world menu' }
RewriteRuleBuilderPresenter class >> icon [

	^ self iconNamed: #configIcon
]

{ #category : #'world menu' }
RewriteRuleBuilderPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'RewriteRuleBuilder')
		parent: #Tools;
		action: [ self open ];
		order: 31;
		icon: self icon;
		help: self helpText
]

{ #category : #'instance creation' }
RewriteRuleBuilderPresenter class >> open [

	^ self new openWithSpec
]

{ #category : #'instance creation' }
RewriteRuleBuilderPresenter class >> withCode: aString [

	| builder |
	builder := self new code: aString.
	^ builder openWithSpec
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> code: aString [

	sourcePanel code: aString.
	transformationRule lhs: aString.
	transformationRule rhs: aString.
	resultPanel code: aString
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> connectPresenters [

	sourcePanel codePresenter whenSubmitDo: [ :aText | 
		self sourcePanelChanged: aText ]
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
		                      yourself
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Rewrite Rule Builder';
		initialExtent: 820 @ 750;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class helpText
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> inputCode [

	^ sourcePanel text
]

{ #category : #'api - accessing' }
RewriteRuleBuilderPresenter >> inputCode: aString [

	sourcePanel code: aString
]

{ #category : #testing }
RewriteRuleBuilderPresenter >> isMatching [

	| rewriter |
	rewriter := self getRewriterFromCodePanels.
	^ rewriter executeTree: sourcePanel ast
]

{ #category : #'api - accessing' }
RewriteRuleBuilderPresenter >> lhs [

	^ transformationRule lhs
]

{ #category : #'api - accessing' }
RewriteRuleBuilderPresenter >> lhs: aString [

	transformationRule lhs: aString
]

{ #category : #'accessing colors' }
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
RewriteRuleBuilderPresenter >> matchSourcePanelCode [

	statusBarForMatch color: self matchColor.
	statusBarForMatch morph infoText: self matchLabel.
	self updateResultPanelAst
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> outputCode [

	^ resultPanel text
]

{ #category : #'api - accessing' }
RewriteRuleBuilderPresenter >> outputCode: aString [

	resultPanel code: aString
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> resultPanel [

	^ resultPanel
]

{ #category : #'api - accessing' }
RewriteRuleBuilderPresenter >> rhs [

	^ transformationRule rhs
]

{ #category : #'api - accessing' }
RewriteRuleBuilderPresenter >> rhs: aString [

	transformationRule rhs: aString
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> sourcePanel [
	^ sourcePanel
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> sourcePanelChanged: aText [

	transformationRule addChangeForPanel: sourcePanel.
	transformationRule undoButton enable.
	sourcePanel ast: (sourcePanel parse: aText).
	self matchSourcePanelCode
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> statusBarForMatch [

	^ statusBarForMatch
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> transformationRule [
	^ transformationRule
]

{ #category : #updating }
RewriteRuleBuilderPresenter >> updateResultPanelAst [

	| rewriter |
	rewriter := self getRewriterFromCodePanels.
	(rewriter executeTree: sourcePanel ast) ifTrue: [ 
		resultPanel ast: rewriter tree ]
]
