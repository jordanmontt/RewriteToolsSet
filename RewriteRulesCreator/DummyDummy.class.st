Class {
	#name : #DummyDummy,
	#superclass : #Object,
	#category : #'RewriteRulesCreator-Demo'
}

{ #category : #'empty protocol 1' }
DummyDummy >> someMethod [
	super size.
	self ifNil: [ ^ true ]
]
