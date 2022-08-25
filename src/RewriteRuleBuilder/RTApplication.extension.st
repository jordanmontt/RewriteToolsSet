Extension { #name : #RTApplication }

{ #category : #'*RewriteRuleBuilder' }
RTApplication >> startRuleBuilder [

	^ (self newPresenter: RewriteRuleBuilderPresenter) open
]
