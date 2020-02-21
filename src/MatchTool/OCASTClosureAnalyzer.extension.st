Extension { #name : #OCASTClosureAnalyzer }

{ #category : #'*MatchTool' }
OCASTClosureAnalyzer >> visitPatternBlockNode: aRBPatternBlockNode [
	self visitBlockNode: aRBPatternBlockNode
]

{ #category : #'*MatchTool' }
OCASTClosureAnalyzer >> visitPatternWrapperBlockNode: aRBPatternWrapperBlockNode [
	self visitNode: aRBPatternWrapperBlockNode wrappedNode.
	self visitBlockNode: aRBPatternWrapperBlockNode
]
