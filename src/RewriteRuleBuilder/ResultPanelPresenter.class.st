"
A ResultPanel is a subclass of AbstractPanel.
Holds result of applying rewrite rule to source code.
Located in top right part of RewriteRuleBuilder.
"
Class {
	#name : #ResultPanelPresenter,
	#superclass : #AbstractPanelPresenter,
	#category : #'RewriteRuleBuilder-Panels'
}

{ #category : #initialization }
ResultPanelPresenter >> initializePresenters [

	super initializePresenters.
	codePresenter beNotEditable.
	self whenBuiltDo: [ 
		codePresenter color: self theme class basePassiveBackgroundColor ]
]

{ #category : #initialization }
ResultPanelPresenter >> labelName [

	^ 'Result code'
]

{ #category : #initialization }
ResultPanelPresenter >> menuActions [
	^ {}
]
