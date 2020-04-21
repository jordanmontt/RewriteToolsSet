"
A ResultPanel is a subclass of AbstractPanel.
Holds result of applying rewrite rule to source code.
Located in top right part of RewriteRuleBuilder.
"
Class {
	#name : #ResultPanelPresenter,
	#superclass : #AbstractPanelPresenter,
	#category : #'RewriteTool-Panels'
}

{ #category : #initialization }
ResultPanelPresenter >> initializePresenters [
	super initializePresenters.
	self whenBuiltDo: [ textModel disable ].
]

{ #category : #initialization }
ResultPanelPresenter >> menuActions [
	^ {}
]
