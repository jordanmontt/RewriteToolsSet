Extension { #name : #RBTransformationRule }

{ #category : #'*RewriteRulesCreator' }
RBTransformationRule >> replaceWith [

	^ rewriteRule replaceWith formattedCode
]

{ #category : #'*RewriteRulesCreator' }
RBTransformationRule >> searchFor [
	^ rewriteRule searchFor formattedCode
]
