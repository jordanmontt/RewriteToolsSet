Class {
	#name : #RTRuleBuilderPresenterTest,
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
RTRuleBuilderPresenterTest >> codeForTheTests [

	^ '| temp | self isNil ifTrue: [ ^ true ]. temp size'
]

{ #category : #defaults }
RTRuleBuilderPresenterTest >> resetPanelsText [

	| defaultCode |
	defaultCode := self codeForTheTests.
	tool inputCode: defaultCode.
	tool lhs: defaultCode.
	tool rhs: defaultCode
]

{ #category : #running }
RTRuleBuilderPresenterTest >> setUp [

	super setUp.
	tool := RewriteRuleBuilderPresenter new code: self codeForTheTests.
	tool buildWithSpec.
	matchText := tool transformationRule matchPanel codePresenter.
	transformText := tool transformationRule transformPanel codePresenter.
	sourceText := tool sourcePanel codePresenter
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testAbstractBlock [

	| selectedNode |
	self skip.
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
RTRuleBuilderPresenterTest >> testAbstractBlockChangesTransformationPanel [

	node := matchText ast statements first arguments first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractBlock.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testAbstractBlockIndex [

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
RTRuleBuilderPresenterTest >> testAbstractCondition [

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
RTRuleBuilderPresenterTest >> testAbstractConditionChangesTransformationPanel [

	node := matchText ast statements first receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractCondition.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testAbstractConditionIndex [

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
RTRuleBuilderPresenterTest >> testAbstractOnlyStatements [

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
RTRuleBuilderPresenterTest >> testAbstractOnlyStatementsChangesTransformationPanel [

	node := RBParser parseExpression: matchText text.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatements.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testAbstractOnlyTemporariesList [

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
RTRuleBuilderPresenterTest >> testAbstractStatement [

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
RTRuleBuilderPresenterTest >> testAbstractStatementChangesTransformationPanel [

	node := matchText ast statements last.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatement.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testAbstractStatementIndex [

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
RTRuleBuilderPresenterTest >> testAbstractStatements [

	node := matchText ast statements.
	matchText selectionInterval:
		(node flatCollect: [ :e | e sourceInterval ]).
	matchText owner abstractStatements.
	self assert: matchText getSelectedNode class equals: RBSequenceNode.
	self
		assert: matchText getSelectedNode formattedCode
		equals: '| temp |
``@.Statements1'
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testAbstractStatementsChangesTransformationPanel [

	node := matchText ast statements.
	matchText selectionInterval:
		(node flatCollect: [ :e | e sourceInterval ]).
	matchText owner abstractStatements.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testAbstractTemporariesList [

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
RTRuleBuilderPresenterTest >> testAbstractTemporariesListChangesTransformationPanel [

	self skip.
	node := matchText ast temporaries first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractTemporariesList.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testAbstractTemporariesListIndex [

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
RTRuleBuilderPresenterTest >> testAbstractVariable [

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
RTRuleBuilderPresenterTest >> testAbstractVariableChangesTransformationPanel [

	node := matchText ast statements first receiver receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractVariable.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testAbstractVariableIndex [

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
RTRuleBuilderPresenterTest >> testChange [

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
RTRuleBuilderPresenterTest >> testChangeChangesTransformationPanel [

	node := matchText ast statements first receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner change: 'super ifNotNil'.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testInteractionWithTheTool [

	| newCode |
	matchText text: 'xafo. k okof >> < <> > > > >'.
	transformText text: 'bla bla'.
	sourceText text: 'temp. super size...'.

	newCode := '| window |
window := RewriteRuleBuilder new openWithSpec'.
	tool inputCode: newCode.
	tool lhs: newCode.
	tool rhs: newCode.
	sourceText triggerSubmitAction.
	matchText triggerSubmitAction.
	transformText triggerSubmitAction.
	newCode := DefaultBuilderRule new inputCode.
	tool inputCode: newCode.
	tool lhs: newCode.
	tool rhs: newCode.
	sourceText triggerSubmitAction.
	matchText triggerSubmitAction.
	transformText triggerSubmitAction.
	
	node := matchText ast receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractMessage.
	node := matchText ast arguments first statements second receiver.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractCondition.
	node := matchText ast arguments first statements first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatement.
	node := matchText ast arguments first temporaries first.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractTemporariesList.
	self assert: true
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testOpen [

	| window |
	window := RewriteRuleBuilderPresenter open.
	self assert: window isBuilt.
	window close
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testOpenApplier [

	| applierWindow |
	applierWindow := tool openApplier.
	self assert: applierWindow isBuilt.
	applierWindow close
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testOpenBasicRuleEditor [

	| basicEditorWindow |
	basicEditorWindow := tool openBasicRuleEditor.
	self assert: basicEditorWindow isBuilt.
	self
		assert: basicEditorWindow presenter searchForPatternCode
		equals: tool lhs.
	self
		assert: basicEditorWindow presenter replaceWithPatternCode
		equals: tool rhs.
	basicEditorWindow close
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testOpenLoader [

	| loaderWindow |
	loaderWindow := tool openLoader.
	self assert: loaderWindow isBuilt.
	loaderWindow close
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testOpenMatchTool [

	| matchToolWindow |
	matchToolWindow := tool openMatchTool.
	self assert: matchToolWindow isBuilt.
	self assert: matchToolWindow presenter patternCode equals: tool lhs.
	self
		assert: matchToolWindow presenter pharoCode
		equals: tool inputCode.
	matchToolWindow close
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testRecurseIntoStatement [

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
RTRuleBuilderPresenterTest >> testRedo [

	self testUndo.
	matchText owner owner owner
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
RTRuleBuilderPresenterTest >> testTransformPanelChangesResultPanel [

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
	self assert: transformText text equals: tool outputCode.
	node := matchText ast statements last.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatement.
	transformText
		text: '| window |
`.@Statement1.
window := RewriteRuleBuilderPresenter new openWithSpec';
		triggerSubmitAction.
	self assert: tool outputCode equals: '| window |
window isBuilt.
window := RewriteRuleBuilderPresenter new openWithSpec'
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testUndo [

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
	matchText owner owner owner
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
RTRuleBuilderPresenterTest >> testUndoOnNode [

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
RTRuleBuilderPresenterTest >> testUndoOnNodeChangesTransformationPanel [

	node := matchText ast statements last.
	matchText selectionInterval: node sourceInterval.
	matchText owner abstractStatement.
	matchText owner undoOnNode.
	self assert: matchText text equals: transformText text
]

{ #category : #tests }
RTRuleBuilderPresenterTest >> testWithCode [

	| window code |
	code := 'a pice of code'.
	window := tool class withCode: code.
	self assert: window presenter lhs equals: code.
	self assert: window presenter rhs equals: code.
	self assert: window presenter inputCode equals: code.
	self assert: window presenter outputCode equals: code.
	window close
]
