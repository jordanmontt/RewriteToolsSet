Extension { #name : #RBStringReplaceRule }

{ #category : #'*RewriteTool' }
RBStringReplaceRule >> lhs [
	^ searchTree
]

{ #category : #'*RewriteTool' }
RBStringReplaceRule >> rhs [
	^ replaceTree
]
