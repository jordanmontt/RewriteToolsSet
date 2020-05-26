"
A ResultPanel is a subclass of AbstractPanel.
Holds result of applying rewrite rule to source code.
Located in top right part of RewriteRuleBuilder.
"
Class {
	#name : #ResultCodePresenter,
	#superclass : #AbstractRuleCodePresenter,
	#category : #'RewriteToolToRefactor-SharedPresenters'
}

{ #category : #initialization }
ResultCodePresenter >> initializePresenters [
	super initializePresenters.
	self whenBuiltDo: [ codePresenter disable ].
	label label: 'Result code:'
]

{ #category : #initialization }
ResultCodePresenter >> menuActions [
	^ {}
]
