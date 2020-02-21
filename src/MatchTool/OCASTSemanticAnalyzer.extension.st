Extension { #name : #OCASTSemanticAnalyzer }

{ #category : #'*MatchTool' }
OCASTSemanticAnalyzer >> visitPatternBlockNode: aNode [


	self visitBlockNode: aNode
]

{ #category : #'*MatchTool' }
OCASTSemanticAnalyzer >> visitPatternWrapperBlockNode: aNode [

	self visitNode: aNode wrappedNode.
	self visitBlockNode: aNode
]
