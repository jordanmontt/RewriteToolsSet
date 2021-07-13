"
A RBCustomTransformationRuleTest is a test class for testing the behavior of RBCustomTransformationRule
"
Class {
	#name : #CustomRewriteRuleTest,
	#superclass : #TestCase,
	#instVars : [
		'customTransformationRule'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
CustomRewriteRuleTest >> setUp [

	super setUp.

	customTransformationRule := CustomRewriteRule new
]

{ #category : #tests }
CustomRewriteRuleTest >> testInputCode [

	customTransformationRule inputCode: 'AnInputCode'.
	self assert: customTransformationRule inputCode equals: 'AnInputCode'
]

{ #category : #tests }
CustomRewriteRuleTest >> testIsDemoRule [

	self deny: customTransformationRule isDemoRule
]

{ #category : #tests }
CustomRewriteRuleTest >> testLhs [

	customTransformationRule lhs: 'pattern'.
	self assert: customTransformationRule lhs isString.
	self assert: customTransformationRule lhs equals: 'pattern'
]

{ #category : #tests }
CustomRewriteRuleTest >> testOutputCode [

	customTransformationRule outputCode: 'AnOutputCode'.
	self
		assert: customTransformationRule outputCode
		equals: 'AnOutputCode'
]

{ #category : #tests }
CustomRewriteRuleTest >> testRhs [

	customTransformationRule rhs: 'pattern'.
	self assert: customTransformationRule rhs isString.
	self assert: customTransformationRule rhs equals: 'pattern'
]
