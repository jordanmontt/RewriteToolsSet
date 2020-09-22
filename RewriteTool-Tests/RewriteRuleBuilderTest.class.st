Class {
	#name : #RewriteRuleBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'tool',
		'node',
		'matchText',
		'transformText',
		'sourceText'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #defaults }
RewriteRuleBuilderTest >> resetPanelsText [

	| defaultCode |
	defaultCode := tool sourcePanel defaultCode.
	tool sourcePanel code: defaultCode.
	tool transformationRule matchPanel code: defaultCode.
	tool transformationRule transformPanel code: defaultCode
]

{ #category : #running }
RewriteRuleBuilderTest >> setUp [

	super setUp.
	tool := RewriteRuleBuilderPresenter new.
	tool buildWithSpec.
	matchText := tool transformationRule matchPanel codePresenter.
	transformText := tool transformationRule transformPanel codePresenter.
	sourceText := tool sourcePanel codePresenter
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractBlock [

	| selectedNode |
	self skip.
	self buildRewriteRuleBuilder.
	node := matchText ast statements first arguments first.
	matchText selectionInterval: node sourceInterval.
	selectedNode := matchText getSelectedNode.
	self assert: selectedNode equals: node.
	matchText owner abstractBlock.
	self
		assert: matchText getSelectedNode class
		equals: RBPatternVariableNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '`@block1'.
	self assert: matchText text equals: '| temp |
self isNil ifTrue: `@block1.
temp size'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractBlockChangesTransformationPanel [

	node := matchText ast statements first arguments first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractBlock.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractBlockIndex [

	node := matchText ast statements first arguments first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractBlock.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '`@block1'.
	self resetPanelsText.
	node := matchText ast statements first arguments first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractBlock.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '`@block2'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractCondition [

	| selectedNode |
	node := matchText ast statements first receiver.
	matchText selectionInterval: node sourceInterval.
	selectedNode := matchText getSelectedNode.
	self assert: selectedNode equals: node.
	matchText owner abstractCondition.
	self
		assert: matchText getSelectedNode class
		equals: RBPatternVariableNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '``@condition1'.
	self assert: matchText text equals: '| temp |
``@condition1 ifTrue: [ ^ true ].
temp size'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractConditionChangesTransformationPanel [

	node := matchText ast statements first receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractCondition.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractConditionIndex [

	node := matchText ast statements first receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractCondition.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '``@condition1'.
	self resetPanelsText.
	node := matchText ast statements first receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractCondition.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '``@condition2'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractOnlyStatements [

	| selectedNode |
	node := matchText ast.
	matchText selectionInterval: node sourceInterval.
	selectedNode := matchText getSelectedNode.
	self assert: selectedNode equals: node.
	matchText owner abstractStatements.
	self assert: matchText getSelectedNode class equals: RBSequenceNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '| temp |
``@.Statements1'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractOnlyStatementsChangesTransformationPanel [

	node := RBParser parseExpression: matchText text.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatements.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractOnlyTemporariesList [

	| selectedNode |
	node := RBParser parseExpression: matchText text.
	matchText selectionInterval: node sourceInterval.
	selectedNode := matchText getSelectedNode.
	self assert: selectedNode equals: node.
	matchText owner abstractTemporariesList.
	self assert: matchText getSelectedNode class equals: RBSequenceNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '| ``@temporaries1 |
self isNil ifTrue: [ ^ true ].
temp size'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractStatement [

	| selectedNode |
	node := matchText ast statements last.
	matchText selectionInterval: node sourceInterval.
	selectedNode := matchText getSelectedNode.
	self assert: selectedNode equals: node.
	matchText owner abstractStatement.
	self
		assert: matchText getSelectedNode class
		equals: RBPatternVariableNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '`.@Statement1'.
	self assert: matchText getSelectedNode isStatement.
	self assert: matchText text equals: '| temp |
self isNil ifTrue: [ ^ true ].
`.@Statement1'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractStatementChangesTransformationPanel [

	node := matchText ast statements last.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatement.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractStatementIndex [

	node := matchText ast statements last.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatement.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '`.@Statement1'.
	self resetPanelsText.
	node := matchText ast statements last.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatement.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '`.@Statement2'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractStatements [

	node := matchText ast statements.
	matchText selectionInterval:
		(node collect: [ :e | e sourceInterval ]) flattened.
	matchText owner abstractStatements.
	self assert: matchText getSelectedNode class equals: RBSequenceNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '| temp |
``@.Statements1'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractStatementsChangesTransformationPanel [

	node := matchText ast statements.
	matchText selectionInterval:
		(node collect: [ :e | e sourceInterval ]) flattened.
	matchText owner abstractStatements.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractTemporariesList [

	| selectedNode |
	self skip.
	node := matchText ast temporaries first.
	matchText selectionInterval: node sourceInterval.
	selectedNode := matchText getSelectedNode.
	self assert: selectedNode equals: node.
	matchText owner abstractTemporariesList.
	self assert: matchText getSelectedNode class equals: RBSequenceNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '| ``@temporaries1 |'.
	self assert: matchText text equals: '| ``@temporaries1 |
self isNil ifTrue: [ ^ true ].
temp size'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractTemporariesListChangesTransformationPanel [

	self skip.
	node := matchText ast temporaries first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractTemporariesList.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractTemporariesListIndex [

	node := matchText ast temporaries first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractTemporariesList.
	self assert: matchText getSelectedNode class equals: RBSequenceNode.
	self assert:
		(matchText getSelectedNode formattedCode includesSubstring:
			 '| ``@temporaries1 |').
	self resetPanelsText.
	node := matchText ast temporaries first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractTemporariesList.
	self assert: matchText getSelectedNode class equals: RBSequenceNode.
	self assert:
		(matchText getSelectedNode formattedCode includesSubstring:
			 '| ``@temporaries2 |')
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractVariable [

	| selectedNode |
	node := matchText ast statements first receiver receiver.
	matchText selectionInterval: node sourceInterval.
	selectedNode := matchText getSelectedNode.
	self assert: selectedNode equals: node.
	matchText owner abstractVariable.
	self
		assert: matchText getSelectedNode class
		equals: RBPatternVariableNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '``@variable1'.
	self assert: matchText text equals: '| temp |
``@variable1 isNil ifTrue: [ ^ true ].
temp size'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractVariableChangesTransformationPanel [

	node := matchText ast statements first receiver receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractVariable.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RewriteRuleBuilderTest >> testAbstractVariableIndex [

	node := matchText ast statements first receiver receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractVariable.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '``@variable1'.
	self resetPanelsText.
	node := matchText ast statements first receiver receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractVariable.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '``@variable2'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testChange [

	| selectedNode |
	node := matchText ast statements first receiver.
	matchText selectionInterval: node sourceInterval.
	selectedNode := matchText getSelectedNode.
	self assert: selectedNode equals: node.
	matchText owner change: 'super ifNotNil'.
	self assert: matchText getSelectedNode class equals: RBMessageNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: 'super ifNotNil'.
	self assert: matchText text equals: '| temp |
super ifNotNil ifTrue: [ ^ true ].
temp size'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testChangeChangesTransformationPanel [

	node := matchText ast statements first receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner change: 'super ifNotNil'.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RewriteRuleBuilderTest >> testChangeTextInPanels [

	| newCode |
	matchText text: 'xafo. k okof >> < <> > > > >'.
	transformText text: 'bla bla'.
	sourceText text: 'temp. super size...'.

	newCode := '| window |
window := RewriteRuleBuilder new openWithSpec'.
	sourceText
		text: newCode.
	matchText
		text: newCode.
	transformText
		text: newCode.
sourceText triggerSubmitAction.
matchText  triggerSubmitAction.
transformText triggerSubmitAction.
	self assert: true
]

{ #category : #tests }
RewriteRuleBuilderTest >> testOpen [

	| window |
	window := RewriteRuleBuilderPresenter new openWithSpec.
	self assert: window isBuilt.
	window close
]

{ #category : #tests }
RewriteRuleBuilderTest >> testRecurseIntoStatement [

	| selectedNode |
	node := matchText ast statements first.
	matchText selectionInterval: node sourceInterval.
	selectedNode := matchText getSelectedNode.
	self assert: selectedNode equals: node.
	matchText owner abstractStatement.
	self
		assert: matchText getSelectedNode class
		equals: RBPatternVariableNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '`.@Statement1'.
	matchText owner recurseInto.
	self
		assert: matchText getSelectedNode class
		equals: RBPatternVariableNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '``.@Statement1'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testRedo [

	self testUndo.
	matchText owner owner
		redo;
		redo;
		redo;
		redo.
	self assert: (matchText text includesSubstring: '``@temporaries1').
	self assert: (matchText text includesSubstring: '``@condition1').
	self assert: (matchText text includesSubstring: '`@block1').
	self assert: (matchText text includesSubstring: '`.@Statement1').
	self assert: (transformText text includesSubstring: '``@condition1').
	self assert: (transformText text includesSubstring: '`@block1').
	self assert: (transformText text includesSubstring: '`.@Statement1')
]

{ #category : #tests }
RewriteRuleBuilderTest >> testTransformPanelChangesResultPanel [

	| newCode |
	newCode := '| window |
window := RewriteRuleBuilderPresenter new openWithSpec.
window isBuilt'.
	sourceText text: newCode.
	matchText text: newCode.
	transformText text: newCode.
	sourceText triggerSubmitAction.
	matchText triggerSubmitAction.
	transformText triggerSubmitAction.
	self
		assert: transformText text
		equals: tool resultPanel codePresenter text.
	node := matchText ast statements last.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatement.
	transformText
		text: '| window |
`.@Statement1.
window := RewriteRuleBuilderPresenter new openWithSpec';
		triggerSubmitAction.
	self assert: tool resultPanel codePresenter text equals: '| window |
window isBuilt.
window := RewriteRuleBuilderPresenter new openWithSpec'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testUndo [

	node := matchText ast temporaries first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractTemporariesList.
	node := matchText ast statements first receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractCondition.
	node := matchText ast statements last.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatement.
	node := matchText ast statements first arguments first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractBlock.
	matchText owner owner
		undo;
		undo;
		undo;
		undo.
	self assert: matchText text equals: '| temp |
self isNil ifTrue: [ ^ true ].
temp size'.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RewriteRuleBuilderTest >> testUndoOnNode [

	node := matchText ast statements last.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatement.
	matchText owner undoOnNode.
	self assert: matchText getSelectedNode class equals: RBMessageNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: 'temp size'.
	self assert: matchText text equals: '| temp |
self isNil ifTrue: [ ^ true ].
temp size'
]

{ #category : #tests }
RewriteRuleBuilderTest >> testUndoOnNodeChangesTransformationPanel [

	node := matchText ast statements last.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatement.
	matchText owner undoOnNode.
	self assert: matchText text equals: transformText text
]
