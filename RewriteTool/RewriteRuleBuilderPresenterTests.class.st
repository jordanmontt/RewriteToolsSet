"
A RewriteRuleBuilderTests is test class for testing RewriteRuleBuilder.

Instance Variables
	matchText:		<MatchPanel>
	node:		<RBProgramNode>
	resultText:		<ResultPanel>
	sourceText:		<SourcePanel>
	tool:		<RewriteRuleBuilder>
	transformText:		<TransformPanel>

matchText
	- an instance of MatchPanel

node
	- selected node

resultText
	- an instance of ResultPanel

sourceText
	- an instance of SourcePanel

tool
	- an instance of RewriteRuleBuilder

transformText
	- an instance of TransformPanel

"
Class {
	#name : #RewriteRuleBuilderPresenterTests,
	#superclass : #TestCase,
	#instVars : [
		'tool',
		'node',
		'matchText',
		'transformText',
		'sourceText',
		'resultText'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #initialization }
RewriteRuleBuilderPresenterTests >> buildRewriteRuleBuilder [
	self tool: RewriteRuleBuilderPresenter new.
	self tool buildWithSpec.
	self matchText: self tool transformationRule searchForPanel textModel.
	self transformText: self tool transformationRule replaceWithPanel textModel.
	self sourceText: self tool sourcePanel textModel.
	self resultText: self tool resultPanel textModel.
	self node: self matchText ast statements first receiver receiver.
	self matchText selectionInterval: self node sourceInterval.
	self transformText selectionInterval: self node sourceInterval.
	self sourceText selectionInterval: self node sourceInterval.
	self resultText selectionInterval: self node sourceInterval
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> matchText [
	^ matchText
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> matchText: anObject [
	matchText := anObject
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> node [
	^ node
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> node: anObject [
	node := anObject
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> resultText [
	^ resultText
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> resultText: anObject [
	resultText := anObject
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> sourceText [
	^ sourceText
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> sourceText: anObject [
	sourceText := anObject
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testAbstractBlockInMatchPanel [
	self buildRewriteRuleBuilder.
	self node: self matchText ast statements first arguments first.
	self matchText selectionInterval: self node sourceInterval.
	self matchText owner abstractBlock.
	self
		assert: self matchText getSelectedNode class
		equals: RBPatternVariableNode.
	self
		assert: self matchText getSelectedNode formattedCode
		equals: '`@block1'.
	self matchText owner owner undo.
	self node: self matchText ast statements first arguments first.
	self matchText owner abstractBlock.
	self matchText selectionInterval: self node sourceInterval.
	self
		assert: self matchText getSelectedNode class
		equals: RBPatternVariableNode.
	self
		assert: self matchText getSelectedNode formattedCode
		equals: '`@block2'
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testAbstractCondition [
	| selectedNode |
	self buildRewriteRuleBuilder.
	self node: self matchText ast statements first receiver.
	self matchText selectionInterval: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner abstractCondition.
	self
		assert: self matchText getSelectedNode class = RBPatternVariableNode.
	self
		assert: self matchText getSelectedNode formattedCode = '``@condition1'
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testAbstractStatement [
	| selectedNode |
	self buildRewriteRuleBuilder.
	self node: self matchText ast statements last.
	self matchText selectionInterval: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner abstractStatement.
	self
		assert: self matchText getSelectedNode class = RBPatternVariableNode.
	self
		assert: self matchText getSelectedNode formattedCode = '`.@Statement1'.
	self assert: self matchText getSelectedNode isStatement
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testAbstractStatements [
	| selectedNode |
	self buildRewriteRuleBuilder.
	self node: (RBParser parseExpression: self matchText text).
	self matchText selectionInterval: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner abstractStatements.
	self assert: self matchText getSelectedNode class = RBSequenceNode.
	self
		assert:
			self matchText getSelectedNode formattedCode
				=
					'| temp |
``@.Statements1'
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testAbstractTemporariesList [
	| selectedNode |
	self buildRewriteRuleBuilder.
	self node: (RBParser parseExpression: self matchText text).
	self matchText selectionInterval: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner abstractStatements.
	self assert: self matchText getSelectedNode class = RBSequenceNode.
	self
		assert:
			self matchText getSelectedNode formattedCode
				=
					'| temp |
``@.Statements1'.
	self matchText owner abstractTemporariesList.
	self assert: self matchText getSelectedNode class = RBSequenceNode.
	self
		assert:
			self matchText getSelectedNode formattedCode
				=
					'| ``@temporaries1 |
``@.Statements1'
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testAbstractVariable1 [
	| selectedNode |
	self buildRewriteRuleBuilder.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner abstractVariable.
	self assert: self matchText getSelectedNode class = RBPatternVariableNode.
	self assert: self matchText getSelectedNode formattedCode = '``@variable1'
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testAbstractVariableInMatchPanel [
	| selectedNode |
	self buildRewriteRuleBuilder.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner abstractVariable.
	self
		assert: self matchText getSelectedNode class = RBPatternVariableNode.
	self
		assert: self matchText getSelectedNode formattedCode = '``@variable1'.
	self
		assert: self matchText getSelectedNode sourceInterval = (10 to: 21).
	self node: self matchText ast statements last receiver.
	self matchText selectionInterval: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner abstractVariable.
	self
		assert: self matchText getSelectedNode class = RBPatternVariableNode.
	self
		assert: self matchText getSelectedNode formattedCode = '``@variable2'.
	self
		assert: self matchText getSelectedNode sourceInterval = (50 to: 61)
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testChangeInMatchPanel [
	| selectedNode |
	self buildRewriteRuleBuilder.
	self node: self matchText ast statements first receiver.
	self matchText selectionInterval: node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner change: 'super ifNotNil'.
	self assert: self matchText getSelectedNode class = RBMessageNode.
	self
		assert: self matchText getSelectedNode formattedCode = 'super ifNotNil'.
	self deny: self transformText getSelectedNode class = RBMessageNode.
	self
		deny: self transformText getSelectedNode formattedCode = 'super ifNotNil'
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testDemoTransformation [
	| selectedNode |
	self buildRewriteRuleBuilder.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode equals: self node.
	self matchText owner abstractVariable.
	self
		assert: self matchText getSelectedNode class
		equals: RBPatternVariableNode.
	self
		assert: self matchText getSelectedNode formattedCode
		equals: '``@variable1'.
	self
		assert: self matchText getSelectedNode sourceInterval
		equals: (10 to: 21).
	self node: self transformText ast statements first receiver receiver.
	self transformText selectionInterval: self node sourceInterval.
	selectedNode := self transformText getSelectedNode.
	self assert: selectedNode equals: self node.
	self node: self matchText ast statements first arguments first.
	self matchText selectionInterval: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode equals: self node.
	self matchText owner abstractBlock.
	self
		assert: self matchText text
		equals:
			'| temp |
``@variable1 isNil
	ifTrue: `@block1.
temp size'.
	self
		assert: self transformText text
		equals:
			'| temp |
``@variable1 isNil
	ifTrue: `@block1.
temp size'.
	self node: self transformText ast statements first.
	self transformText setSelection: self node sourceInterval.
	selectedNode := self transformText getSelectedNode.
	self assert: selectedNode equals: self node.
	self
		assert: self resultText text
		equals:
			'| temp |
self isNil
	ifTrue: [ ^ true ].
temp size'
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testRecurseIntoStatement [
	| selectedNode |
	self buildRewriteRuleBuilder.
	selectedNode := self matchText getSelectedNode.
	self node: self matchText getSelectedNode parent.
	self matchText owner abstractStatement.
	self
		assert: self matchText getSelectedNode class = RBPatternVariableNode.
	self
		assert: self matchText getSelectedNode formattedCode = '`.@Statement1'.
	self matchText owner recurseInto.
	self
		assert: self matchText getSelectedNode class = RBPatternVariableNode.
	self
		assert: self matchText getSelectedNode formattedCode = '``.@Statement1'
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testRedoInMatchPanel [
	| selectedNode |
	self buildRewriteRuleBuilder.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner abstractVariable.
	self
		assert: self matchText getSelectedNode class = RBPatternVariableNode.
	self
		assert: self matchText getSelectedNode formattedCode = '``@variable1'.
	self node: self matchText ast statements last receiver.
	self matchText selectionInterval: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner owner undo.
	self
		assert:
			self matchText text
				=
					'| temp |
self isNil
	ifTrue: [ ^ true ].
temp size'.
	self matchText owner owner redo.
	self
		assert:
			self matchText text
				=
					'| temp |
``@variable1 isNil
	ifTrue: [ ^ true ].
temp size'
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testUndoAfterComplexTransformation [
	| selectedNode |
	self testDemoTransformation.
	self node: self matchText ast.
	self matchText setSelection: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner owner undo.
	self
		assert:
			self transformText text
				=
					'| temp |
``@variable1 isNil
	ifTrue: [ ^ true ].
temp size'.
	self node: self matchText ast.
	self matchText setSelection: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner owner undo.
	self
		assert:
			self transformText text
				=
					'| temp |
self isNil
	ifTrue: [ ^ true ].
temp size'.
	self node: self matchText ast.
	self matchText setSelection: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self node: self matchText ast.
	self matchText setSelection: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self
		assert:
			self transformText text
				=
					'| temp |
self isNil
	ifTrue: [ ^ true ].
temp size'
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testUndoInMatchPanel [
	| selectedNode |
	self buildRewriteRuleBuilder.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner abstractVariable.
	self
		assert: self matchText getSelectedNode class = RBPatternVariableNode.
	self
		assert: self matchText getSelectedNode formattedCode = '``@variable1'.
	self node: self matchText ast statements last receiver.
	self matchText selectionInterval: self node sourceInterval.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner owner undo.
	self
		assert:
			self matchText text
				=
					'| temp |
self isNil
	ifTrue: [ ^ true ].
temp size'
]

{ #category : #tests }
RewriteRuleBuilderPresenterTests >> testUndoNodeAfterOneAbstract [
	| selectedNode |
	self buildRewriteRuleBuilder.
	selectedNode := self matchText getSelectedNode.
	self assert: selectedNode = self node.
	self matchText owner abstractVariable.
	self assert: self matchText getSelectedNode class = RBPatternVariableNode.
	self assert: self matchText getSelectedNode formattedCode = '``@variable1'.
	selectedNode := self matchText getSelectedNode.
	self matchText owner undoOnNode.
	self assert: self matchText getSelectedNode class = RBSelfNode.
	self assert: self matchText getSelectedNode formattedCode = 'self'
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> tool [
	^ tool
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> tool: anObject [
	tool := anObject
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> transformText [
	^ transformText
]

{ #category : #accessing }
RewriteRuleBuilderPresenterTests >> transformText: anObject [
	transformText := anObject
]
