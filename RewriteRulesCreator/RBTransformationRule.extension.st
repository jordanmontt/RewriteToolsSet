Extension { #name : #RBTransformationRule }

{ #category : #'*RewriteRulesCreator' }
RBTransformationRule >> lhs [
	^ rewriteRule lhs formattedCode
]

{ #category : #'*RewriteRulesCreator' }
RBTransformationRule >> rhs [
	^ rewriteRule rhs formattedCode
]
