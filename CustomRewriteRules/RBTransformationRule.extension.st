Extension { #name : #RBTransformationRule }

{ #category : #'*CustomRewriteRules' }
RBTransformationRule >> replaceWith [

	^ rewriteRule replaceWith formattedCode
]

{ #category : #'*CustomRewriteRules' }
RBTransformationRule >> searchFor [
	^ rewriteRule searchFor formattedCode
]
