"
A ResultPanel is a subclass of AbstractPanel.
Holds result of applying rewrite rule to source code.
Located in top right part of RewriteRuleBuilder.
"
Class {
	#name : #ResultPanelPresenter,
	#superclass : #AbstractPanelPresenter,
	#category : #'RewriteTool-SharedPresenters'
}

{ #category : #initialization }
ResultPanelPresenter >> initializePresenters [
	super initializePresenters.
	self whenBuiltDo: [ codePresenter disable ].
]

{ #category : #initialization }
ResultPanelPresenter >> menuActions [
	^ {}
]
