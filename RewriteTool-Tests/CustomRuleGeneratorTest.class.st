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

{ #category : #test }
CustomRuleGeneratorTest >> testDoubleSingleQuotes [

	self
		assert: (customRuleGenerator doubleSingleQuotes:
				 'onlyMyRulesCheckbox := self newCheckBox label: ''Only my rules''.
applyOnSelectedButton := self newButton label: ''On selected classes''.
applyOnAllButton := self newButton label: ''On all classes''')
		equals:
			'onlyMyRulesCheckbox := self newCheckBox label: ''''Only my rules''''.
applyOnSelectedButton := self newButton label: ''''On selected classes''''.
applyOnAllButton := self newButton label: ''''On all classes'''''
]

{ #category : #test }
CustomRuleGeneratorTest >> testGenerateRuleForPackage [

	| searchForPattern replaceWithPattern inputCode outputCode temporaryCustomRule |
	searchForPattern := '`@expression ifTrue: [ `@codeBlock ]'.
	replaceWithPattern := '`@expression ifFalse: [ ^ self ].
`@codeBlock'.
	inputCode := 'window isBuilt ifTrue: [window close]'.
	outputCode := 'window isBuilt ifFalse: [ ^ self ].
window close'.
	customRuleGenerator
		searchFor: searchForPattern;
		replaceWith: replaceWithPattern;
		inputCode: inputCode;
		outputCode: outputCode.
	temporaryCustomRule := (customRuleGenerator
		                        generateRule:
		                        'TemporaryCustomRuleForTesting'
		                        forPackage: 'Custom') new.
	self assert: (temporaryCustomRule isKindOf: RBTransformationRule).
	self assert:
		(temporaryCustomRule isKindOf: RBCustomTransformationRule).
	self assert: temporaryCustomRule lhs equals: searchForPattern.
	self assert: temporaryCustomRule rhs equals: replaceWithPattern.
	self assert: temporaryCustomRule outputCode equals: outputCode.
	self assert: temporaryCustomRule inputCode equals: inputCode.
	self assert:
		(temporaryCustomRule class package name includesSubstring:
			 customRuleGenerator class packageName).
	temporaryCustomRule class removeFromSystem
]

{ #category : #test }
CustomRuleGeneratorTest >> testGetAllRulesAsClasses [

	self
		assertCollection: customRuleGenerator class getAllRulesAsClasses
		hasSameElements: RBCustomTransformationRule subclasses
]

{ #category : #test }
CustomRuleGeneratorTest >> testInitialize [

	self assert: customRuleGenerator inputCode isNotNil.
	self assert: customRuleGenerator outputCode isNotNil
]

{ #category : #test }
CustomRuleGeneratorTest >> testInputCode [

	customRuleGenerator inputCode: 'anInputCode'.
	self assert: customRuleGenerator inputCode equals: 'anInputCode'
]

{ #category : #test }
CustomRuleGeneratorTest >> testOutputCode [

	customRuleGenerator inputCode: 'anOutputCode'.
	self assert: customRuleGenerator inputCode equals: 'anOutputCode'
]

{ #category : #test }
CustomRuleGeneratorTest >> testPackageName [

	| allSystemPackages filteredPackages |
	allSystemPackages := RBBrowserEnvironment new packages.
	filteredPackages := allSystemPackages select: [ :each | 
		                     each name
		                     = customRuleGenerator class packageName ].
	self assert: filteredPackages isNotEmpty
]

{ #category : #test }
CustomRuleGeneratorTest >> testReplaceWith [

	customRuleGenerator replaceWith: 'replaceWithCode'.
	self
		assert: customRuleGenerator replaceWith
		equals: 'replaceWithCode'
]

{ #category : #test }
CustomRuleGeneratorTest >> testRuleInitializationMethod [

	| inputCode |
	inputCode := 'aPackage includesSubstring: ''Collection'''.
	customRuleGenerator replaceWith: 'replaceWithCode'.
	customRuleGenerator searchFor: 'searchForCode'.
	customRuleGenerator inputCode: inputCode.
	customRuleGenerator outputCode: 'outputCode'.
	self assert:
		(customRuleGenerator ruleInitializationMethod includesSubstring:
			 'super initialize.').
	self assert:
		(customRuleGenerator ruleInitializationMethod includesSubstring:
			 'replaceWithCode').
	self assert:
		(customRuleGenerator ruleInitializationMethod includesSubstring:
			 'searchForCode').
	self assert:
		(customRuleGenerator ruleInitializationMethod includesSubstring:
			 'aPackage includesSubstring: ''''Collection''''').
	self assert:
		(customRuleGenerator ruleInitializationMethod includesSubstring:
			 'outputCode').
	self assert:
		(customRuleGenerator ruleInitializationMethod includesSubstring:
			 'rewriteRule replace:')
]

{ #category : #test }
CustomRuleGeneratorTest >> testSearchFor [

	customRuleGenerator searchFor: 'searchForCode'.
	self assert: customRuleGenerator searchFor equals: 'searchForCode'
]
