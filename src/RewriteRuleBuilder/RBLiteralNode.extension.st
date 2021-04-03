Extension { #name : #RBLiteralNode }

{ #category : #'*RewriteRuleBuilder' }
RBLiteralNode >> isInTemporariesList [
	^ false
]

{ #category : #'*RewriteRuleBuilder' }
RBLiteralNode >> optionsForNode [

	| options |
	options := super optionsForNode.
	options
		add: #( 'Abstract literal' #abstractLiteral );
		add: #( 'Abstract object' #abstractMessage ).
	^ options
]
