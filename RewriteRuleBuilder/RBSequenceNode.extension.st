Extension { #name : #RBSequenceNode }

{ #category : #'*RewriteRuleBuilder' }
RBSequenceNode >> isInTemporariesList [
	^ true
]

{ #category : #'*RewriteRuleBuilder' }
RBSequenceNode >> optionsForNode [

	| options |
	options := super optionsForNode.
	self temporaries isNotEmpty ifTrue: [ 
		options add:
			#( 'Abstract temporaries list' #abstractTemporariesList ) ].
	options add: #( 'Abstract statements' #abstractStatements ).
	^ options
]
