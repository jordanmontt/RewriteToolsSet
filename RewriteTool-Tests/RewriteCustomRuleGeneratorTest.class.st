Class {
	#name : #RewriteCustomRuleGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'customRuleGenerator'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #defaults }
RewriteCustomRuleGeneratorTest >> createDirtyClassForTesting: aClassName [

	| classWithDirtyMethod |
	classWithDirtyMethod := Object
		                        subclass: aClassName
		                        instanceVariableNames: ''
		                        classVariableNames: ''
		                        package:
		                        RewriteCustomRuleGenerator packageName
		                        , '-JustForTesting'.
	classWithDirtyMethod
		compile: 'aMethod
		a = b ifTrue: [ ^ self]'
		classified: 'initialization'.
	^ classWithDirtyMethod
]

{ #category : #defaults }
RewriteCustomRuleGeneratorTest >> createRuleForTesting [

	^ RewriteCustomRuleGenerator new
		  searchFor: '`@expression ifTrue: [ `@codeBlock ]';
		  replaceWith: '`@expression ifFalse: [ ^ self ]. `@codeBlock';
		  generateRule: 'ATemporaryRuleForTestingApplier'
		  forPackage: 'JustForTesting'
]

{ #category : #running }
RewriteCustomRuleGeneratorTest >> setUp [

	super setUp.
	customRuleGenerator := RewriteCustomRuleGenerator new
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testDoubleSingleQuotes [

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
RewriteCustomRuleGeneratorTest >> testGenerateRuleForPackage [

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
		                        'Temporary custom rule for testing'
		                        forPackage: 'Custom') new.
	self assert: (temporaryCustomRule isKindOf: CustomRewriteRule).
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
RewriteCustomRuleGeneratorTest >> testGetAllRules [

	self
		assertCollection: customRuleGenerator class getAllRules
		hasSameElements: CustomRewriteRule subclasses
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testGetAllRulesAsClasses [

	self
		assertCollection: customRuleGenerator class getAllRules
		hasSameElements: CustomRewriteRule subclasses
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testGetInstanceRule [

	| instanceRule searchForString replaceWithString |
	searchForString := 'searchForPattern'.
	replaceWithString := 'replaceWithPattern'.
	instanceRule := customRuleGenerator
		                searchFor: searchForString;
		                replaceWith: replaceWithString;
		                getInstanceRule.
	self assert: (instanceRule isKindOf: ReAbstractRule).
	self assert: (instanceRule isMemberOf: ReNodeRewriteRule)
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testGetOnlyCustomRules [

	self
		assertCollection: customRuleGenerator class getOnlyCustomRules
		hasSameElements:
			(CustomRewriteRule subclasses reject: [ :rule | 
				 rule new isDemoRule ])
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testInitialize [

	self assert: customRuleGenerator inputCode isNotNil.
	self assert: customRuleGenerator outputCode isNotNil
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testInputCode [

	customRuleGenerator inputCode: 'anInputCode'.
	self assert: customRuleGenerator inputCode equals: 'anInputCode'
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testInvalidRuleNameAlert [

	| alert |
	alert := customRuleGenerator invalidRuleNameAlert.
	self assert: (alert isMemberOf: MorphicUIManager)
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testObtainChangesForRule [

	| changes rule dirtyClass |
	rule := self createRuleForTesting.
	dirtyClass := self createDirtyClassForTesting:
		              'ADirtyClassForThisTest'.
	changes := RewriteCustomRuleGenerator
		           obtainChanges: { dirtyClass }
		           forRule: rule new.
	self denyEmpty: changes.
	rule removeFromSystem.
	dirtyClass removeFromSystem
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testOutputCode [

	customRuleGenerator inputCode: 'anOutputCode'.
	self assert: customRuleGenerator inputCode equals: 'anOutputCode'
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testPackageName [

	| allSystemPackages filteredPackages |
	allSystemPackages := RBBrowserEnvironment new packages.
	filteredPackages := allSystemPackages select: [ :each | 
		                     each name
		                     = customRuleGenerator class packageName ].
	self assert: filteredPackages isNotEmpty
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testReplaceWith [

	customRuleGenerator replaceWith: 'replaceWithCode'.
	self
		assert: customRuleGenerator replaceWith
		equals: 'replaceWithCode'
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testRuleInitializationMethod [

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
			 'self replace:')
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testRuleNameMethod [

	| aRuleName ruleNameMethod |
	aRuleName := 'This is a name'.
	ruleNameMethod := customRuleGenerator ruleNameMethod: aRuleName.
	self assert: (ruleNameMethod includesSubstring: '^').
	self assert:
		(ruleNameMethod includesSubstring: '''' , aRuleName , '''')
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testRuleSuccessfullyCreatedAlert [

	| alert |
	alert := customRuleGenerator ruleSuccessfullyCreatedAlert.
	self assert: (alert isMemberOf: MorphicUIManager)
]

{ #category : #test }
RewriteCustomRuleGeneratorTest >> testSearchFor [

	customRuleGenerator searchFor: 'searchForCode'.
	self assert: customRuleGenerator searchFor equals: 'searchForCode'
]
