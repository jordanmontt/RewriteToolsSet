Extension { #name : #RBStringReplaceRule }

{ #category : #'*RewriteRulesCreator' }
RBStringReplaceRule >> lhs [
	^ searchTree
]

{ #category : #'*RewriteRulesCreator' }
RBStringReplaceRule >> rhs [
	^ replaceTree
]
