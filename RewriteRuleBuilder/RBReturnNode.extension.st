Extension { #name : #RBReturnNode }

{ #category : #'*RewriteRuleBuilder' }
RBReturnNode >> optionsForNode [

	| options |
	options := super optionsForNode.
	options add: #( 'Abstract object' #abstractMessage ).
	^ options
]
