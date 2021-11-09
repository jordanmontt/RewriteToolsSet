Extension { #name : #CmCommand }

{ #category : #'*RewriteRuleTools' }
CmCommand class >> asSpecButtonForContext: anObject [

	| specCommand button |
	specCommand := self new
		context: anObject;
		asSpecCommand.
	button := specCommand asButtonPresenter.
	button iconName: self iconName.
	^ button
]
