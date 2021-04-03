Extension { #name : #RBBlockNode }

{ #category : #'*RewriteRuleBuilder' }
RBBlockNode >> optionsForNode [

	| options |
	options := super optionsForNode.
	options add: #( 'Abstract block' #abstractBlock ).
	^ options
]
