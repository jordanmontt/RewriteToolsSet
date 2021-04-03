Extension { #name : #RBMessageNode }

{ #category : #'*RewriteRuleBuilder' }
RBMessageNode >> optionsForNode [

	| options |
	options := super optionsForNode.
	options add: #( 'Abstract statement' #abstractStatement ).
	options add: #( 'Abstract object' #abstractMessage ).
	self parent class = self class ifTrue: [ 
		(self conditionalSelectors anySatisfy: [ :sel | 
			 sel = self parent selector ]) ifTrue: [ 
			| position1 position2 |
			position1 := options indexOf:
				             #( 'Abstract object' #abstractMessage ).
			position2 := options indexOf:
				             #( 'Abstract statement' #abstractStatement ).
			options
				removeAt: position1;
				removeAt: position2.
			options add: #( 'Abstract condition' #abstractCondition ) ] ].
	^ options
]

{ #category : #'*RewriteRuleBuilder' }
RBMessageNode >> selectorIgnoreNumberOfArgs: aSelector [

	| keywords numArgs selectorParts |
	"selectorParts variable was added to temp variables declaration because it does not exists and was giving an error."
	keywords := aSelector keywords.
	numArgs := aSelector numArgs.
	selectorParts := numArgs == 0
		                 ifTrue: [ 
		                 Array with:
			                 (RBIdentifierToken
				                  value: keywords first
				                  start: nil) ]
		                 ifFalse: [ 
			                 keywords first last = $:
				                 ifTrue: [ 
				                 keywords collect: [ :each | 
					                 RBKeywordToken value: each start: nil ] ]
				                 ifFalse: [ 
				                 Array with:
					                 (RBBinarySelectorToken
						                  value: aSelector
						                  start: nil) ] ].
	selector := aSelector asSymbol
]
