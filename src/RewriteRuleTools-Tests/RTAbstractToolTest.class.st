Class {
	#name : #RTAbstractToolTest,
	#superclass : #TestCase,
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

{ #category : #tests }
RTAbstractToolTest >> testTitle [

	self deny: self toolClass title equals: 'Untitled window'
]

{ #category : #accessing }
RTAbstractToolTest >> toolClass [

	^ self subclassResponsibility
]
