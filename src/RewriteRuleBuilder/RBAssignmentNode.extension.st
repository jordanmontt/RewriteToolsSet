Extension { #name : #RBAssignmentNode }

{ #category : #'*RewriteRuleBuilder' }
RBAssignmentNode >> optionsForNode [

	| options |
	options := super optionsForNode.
	options add: #( 'Abstract statement' #abstractStatement ).
	^ options
]
