Extension { #name : #RBTransformationRule }

{ #category : #'*RewriteTool' }
RBTransformationRule >> input [
	^ String empty
]

{ #category : #'*RewriteTool' }
RBTransformationRule >> lhs [
	^ rewriteRule lhs formattedCode
]

{ #category : #'*RewriteTool' }
RBTransformationRule >> output [
	^ String empty
]

{ #category : #'*RewriteTool' }
RBTransformationRule >> rhs [
	^ rewriteRule rhs formattedCode
]
