"
A RBCustomTransformationRuleTest is a test class for testing the behavior of RBCustomTransformationRule
"
Class {
	#name : #RBCustomTransformationRuleTest,
	#superclass : #TestCase,
	#instVars : [
		'customTransformationRule'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RBCustomTransformationRuleTest >> setUp [

	super setUp.

	customTransformationRule := CustomRewriteRule new
]

{ #category : #test }
RBCustomTransformationRuleTest >> testInputCode [

	customTransformationRule inputCode: 'AnInputCode'.
	self assert: customTransformationRule inputCode equals: 'AnInputCode'
]

{ #category : #test }
RBCustomTransformationRuleTest >> testIsDemoRule [

	self deny: customTransformationRule isDemoRule
]

{ #category : #test }
RBCustomTransformationRuleTest >> testOutputCode [

	customTransformationRule outputCode: 'AnOutputCode'.
	self
		assert: customTransformationRule outputCode
		equals: 'AnOutputCode'
]
