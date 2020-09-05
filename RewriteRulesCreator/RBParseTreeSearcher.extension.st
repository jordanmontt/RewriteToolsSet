Extension { #name : #RBParseTreeSearcher }

{ #category : #'*RewriteRulesCreator' }
RBParseTreeSearcher >> replaceWith [

	^ searches first replaceWith
]

{ #category : #'*RewriteRulesCreator' }
RBParseTreeSearcher >> searchFor [

	^ searches first searchFor
]
