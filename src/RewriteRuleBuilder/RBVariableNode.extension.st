Extension { #name : #RBVariableNode }

{ #category : #'*RewriteRuleBuilder' }
RBVariableNode >> isInTemporariesList [
	^ self getSequenceParent temporaries
		ifEmpty: [ false ]
		ifNotEmpty: [ self start > self getSequenceParent leftBar and: [ self stop < self getSequenceParent rightBar ] ]
]

{ #category : #'*RewriteRuleBuilder' }
RBVariableNode >> optionsForNode [

	| options |
	options := super optionsForNode.
	self isInTemporariesList
		ifTrue: [ 
			options add:
				#( 'Abstract temporaries list' #abstractTemporariesList ) ]
		ifFalse: [ options add: #( 'Abstract object' #abstractVariable ) ].
	^ options
]
