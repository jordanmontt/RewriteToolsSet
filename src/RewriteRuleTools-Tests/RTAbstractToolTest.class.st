Class {
	#name : #RTAbstractToolTest,
	#superclass : #TestCase,
	#instVars : [
		'tool'
	],
	#category : #'RewriteRuleTools-Tests-AbstractTestClass'
}

{ #category : #testing }
RTAbstractToolTest class >> isAbstract [

	^ self = RTAbstractToolTest
]

{ #category : #tests }
RTAbstractToolTest >> testDescriptionText [

	self assert: self toolClass descriptionText isString.
	self assert: self toolClass descriptionText isNotEmpty
]

{ #category : #tests }
RTAbstractToolTest >> testIcon [

	self assert: self toolClass icon isForm
]

{ #category : #tests }
RTAbstractToolTest >> testIconName [

	self assert: self toolClass iconName isSymbol
]

{ #category : #accessing }
RTAbstractToolTest >> toolClass [

	^ self subclassResponsibility
]
