"
A ResultPanel is a subclass of AbstractPanel.
Holds result of applying rewrite rule to source code.
Located in top right part of RewriteRuleBuilder.
"
Class {
	#name : #ResultPanel,
	#superclass : #AbstractPanel,
	#category : #'RewriteTool-Panels'
}

{ #category : #initialization }
ResultPanel >> initializeWidgets [
	super initializeWidgets.
	self whenBuiltDo: [ self textModel disable ]
]

{ #category : #initialization }
ResultPanel >> menuActions [
	^ {}
]
