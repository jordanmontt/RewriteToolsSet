Class {
	#name : #CustomRuleGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'customRuleGenerator'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
CustomRuleGeneratorTest >> setUp [

	super setUp.
	customRuleGenerator := CustomRuleGenerator new
]

{ #category : #tests }
CustomRuleGeneratorTest >> testGenerateRuleForPackage [

	| searchForPattern replaceWithPattern temporaryCustomRule |
	searchForPattern := '`@expression ifTrue: [ `@codeBlock ]'.
	replaceWithPattern := '`@expression ifFalse: [ ^ self ].
`@codeBlock'.
	customRuleGenerator
		searchFor: searchForPattern;
		replaceWith: replaceWithPattern.
	temporaryCustomRule := (customRuleGenerator
		                        generateRule:
		                        'TemporaryCustomRuleForTesting'
		                        forPackage: 'Custom') new.
	self
		assert: (customRuleGenerator
				 generateRule: 'anInvalidClassName'
				 forPackage: 'Custom')
		equals: nil.
	self assert: (temporaryCustomRule isKindOf: RBTransformationRule).
	self assert: temporaryCustomRule searchFor equals: searchForPattern.
	self
		assert: temporaryCustomRule replaceWith
		equals: replaceWithPattern.
	temporaryCustomRule class removeFromSystem
]
