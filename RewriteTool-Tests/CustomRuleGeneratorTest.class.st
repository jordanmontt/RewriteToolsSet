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
		replaceWith: replaceWithPattern;
		generateRule: 'TemporaryCustomRuleForTesting' forPackage: 'Custom'.
	temporaryCustomRule := (self class environment classNamed:
		                        'TemporaryCustomRuleForTesting') new.
	self deny: temporaryCustomRule equals: nil.
	self assert: temporaryCustomRule searchFor equals: searchForPattern.
	self
		assert: temporaryCustomRule replaceWith
		equals: replaceWithPattern.
	temporaryCustomRule class removeFromSystem
]
