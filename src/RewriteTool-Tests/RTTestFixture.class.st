"
I am a class for helping the tests
"
Class {
	#name : #RTTestFixture,
	#superclass : #Object,
	#category : #'RewriteTool-Tests'
}

{ #category : #defaults }
RTTestFixture class >> createDirtyClassForTesting: aClassName [

	| classWithDirtyMethod |
	classWithDirtyMethod := Object
		subclass: aClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'APackageForTesting-JustForTesting'.

	classWithDirtyMethod
		compile: 'aMethod
		a = b ifTrue: [ ^ self]'
		classified: 'initialization'.
	^ classWithDirtyMethod
]
