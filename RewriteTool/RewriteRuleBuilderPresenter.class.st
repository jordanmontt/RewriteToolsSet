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
		'inputLabel',
		'outputLabel',
		'statusBarForResult',
		'statusBarForMatch'
	],
	#category : #'RewriteTool-Core'
}

{ #category : #specs }
RewriteRuleBuilderPresenter class >> defaultSpec [

	| sourcePanel resultPanel |
	sourcePanel := SpBoxLayout newVertical
		               add: #inputLabel expand: false;
		               add: #sourcePanel;
		               add: #statusBarForMatch height: 40;
		               yourself.
	resultPanel := SpBoxLayout newVertical
		               add: #outputLabel expand: false;
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

	^ 'Abstract Pharo code into a Rewrite Rule without the need of knowing the syntax'
]

{ #category : #'world menu' }
RewriteRuleBuilderPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'RewriteRuleBuilder')
		parent: #Tools;
		action: [ self open ];
		icon: (self iconNamed: #configIcon);
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
	transformationRule matchPanel code: aString.
	transformationRule transformPanel code: aString.
	resultPanel code: aString
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> connectPresenters [

	sourcePanel codePresenter whenSubmitDo: [ :aText | 
		self sourcePanelChanged: aText ]
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> createStatusBarMatchMorph [

	^ (TransformationRulePresenter arrowMorph: ActivePolygonMorph)
		  rotationDegrees: 90;
		  color: self matchColor;
		  infoText: self matchLabel;
		  yourself
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> createStatusBarResultMorph [

	^ (TransformationRulePresenter arrowMorph: ActivePolygonMorph)
		  rotationDegrees: -90;
		  infoText: 'Result of applying rule to source code';
		  yourself
]

{ #category : #defaults }
RewriteRuleBuilderPresenter >> getRewriterFromCodePanels [

	^ RBParseTreeRewriter new
		  replace: transformationRule matchPanel codePresenter text
		  with: transformationRule transformPanel codePresenter text
]

{ #category : #initialization }
RewriteRuleBuilderPresenter >> initializePresenters [

	inputLabel := self newLabel label: 'Source code'.
	outputLabel := self newLabel label: 'Result code'.
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
		initialExtent: 800 @ 750
]

{ #category : #testing }
RewriteRuleBuilderPresenter >> isMatching [

	| rewriter |
	rewriter := self getRewriterFromCodePanels.
	^ rewriter executeTree: sourcePanel codePresenter ast
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
RewriteRuleBuilderPresenter >> resultPanel [

	^ resultPanel
]

{ #category : #accessing }
RewriteRuleBuilderPresenter >> sourcePanel [
	^ sourcePanel
]

{ #category : #actions }
RewriteRuleBuilderPresenter >> sourcePanelChanged: aText [

	transformationRule addChangeForPanel: sourcePanel.
	transformationRule undoButton enable.
	sourcePanel codePresenter ast: (sourcePanel parse: aText).
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
	(rewriter executeTree: sourcePanel codePresenter ast) ifTrue: [ 
		resultPanel codePresenter ast: rewriter tree ]
]
