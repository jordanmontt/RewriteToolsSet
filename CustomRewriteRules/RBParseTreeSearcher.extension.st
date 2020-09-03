Extension { #name : #RBParseTreeSearcher }

{ #category : #'*CustomRewriteRules' }
RBParseTreeSearcher >> replaceWith [

	^ searches first replaceWith
]

{ #category : #'*CustomRewriteRules' }
RBParseTreeSearcher >> searchFor [

	^ searches first searchFor
]
