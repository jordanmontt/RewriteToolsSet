Class {
	#name : #RTCustomRuleGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'customRuleGenerator'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #defaults }
RTCustomRuleGeneratorTest >> createDirtyClassForTesting: aClassName [

	| classWithDirtyMethod |
	classWithDirtyMethod := Object
		                        subclass: aClassName
		                        instanceVariableNames: ''
		                        classVariableNames: ''
		                        package:
		                        RTCustomRuleGenerator packageName
		                        , '-JustForTesting'.
	classWithDirtyMethod
		compile: 'aMethod
		a = b ifTrue: [ ^ self]'
		classified: 'initialization'.
	^ classWithDirtyMethod
]

{ #category : #defaults }
RTCustomRuleGeneratorTest >> createRuleForTesting [

	^ RTCustomRuleGenerator new
		  searchFor: '`@expression ifTrue: [ `@codeBlock ]';
		  replaceWith: '`@expression ifFalse: [ ^ self ]. `@codeBlock';
		  generateRule: 'ATemporaryRuleForTestingApplier'
		  forPackage: 'JustForTesting' isForMethod: false
]

{ #category : #running }
RTCustomRuleGeneratorTest >> setUp [

	super setUp.
	customRuleGenerator := RTCustomRuleGenerator new
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testDoubleSingleQuotes [

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

{ #category : #tests }
RTCustomRuleGeneratorTest >> testGenerateRuleForPackageIsForMethod [

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
		                        forPackage: 'Custom'
		                        isForMethod: false) new.
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

{ #category : #tests }
RTCustomRuleGeneratorTest >> testGetAllRules [

	self
		assertCollection: customRuleGenerator class getAllRules
		hasSameElements: CustomRewriteRule subclasses
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testGetAllRulesAsClasses [

	self
		assertCollection: customRuleGenerator class getAllRules
		hasSameElements: CustomRewriteRule subclasses
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testGetInstanceRule [

	| instanceRule searchForString replaceWithString |
	searchForString := 'searchForPattern'.
	replaceWithString := 'replaceWithPattern'.
	instanceRule := customRuleGenerator
		                searchFor: searchForString;
		                replaceWith: replaceWithString;
		                getInstanceRule: false.
	self assert: (instanceRule isKindOf: ReAbstractRule).
	self assert: (instanceRule isMemberOf: ReNodeRewriteRule)
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testGetOnlyCustomRules [

	self
		assertCollection: customRuleGenerator class getOnlyCustomRules
		hasSameElements:
			(CustomRewriteRule subclasses reject: [ :rule | 
				 rule new isDemoRule ])
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testInitialize [

	self assert: customRuleGenerator inputCode isNotNil.
	self assert: customRuleGenerator outputCode isNotNil
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testInputCode [

	customRuleGenerator inputCode: 'anInputCode'.
	self assert: customRuleGenerator inputCode equals: 'anInputCode'
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testInvalidRuleNameAlert [

	| alert |
	alert := customRuleGenerator invalidRuleNameAlert.
	self assert: (alert isMemberOf: MorphicUIManager)
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testObtainChangesForRules [

	| changes rule dirtyClass |
	rule := self createRuleForTesting.
	dirtyClass := self createDirtyClassForTesting:
		              'ADirtyClassForThisTest'.
	changes := RTCustomRuleGenerator
		           obtainChanges: { dirtyClass }
		           forRules: { rule new }.
	self denyEmpty: changes.
	rule removeFromSystem.
	dirtyClass removeFromSystem
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testOutputCode [

	customRuleGenerator inputCode: 'anOutputCode'.
	self assert: customRuleGenerator inputCode equals: 'anOutputCode'
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testPackageName [

	| allSystemPackages filteredPackages |
	allSystemPackages := RBBrowserEnvironment new packages.
	filteredPackages := allSystemPackages select: [ :each | 
		                     each name
		                     = customRuleGenerator class packageName ].
	self assert: filteredPackages isNotEmpty
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testReplaceWith [

	customRuleGenerator replaceWith: 'replaceWithCode'.
	self
		assert: customRuleGenerator replaceWith
		equals: 'replaceWithCode'
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testRuleInitializationMethod [

	| inputCode methodString |
	inputCode := 'aPackage includesSubstring: ''Collection'''.
	customRuleGenerator replaceWith: 'replaceWithCode'.
	customRuleGenerator searchFor: 'searchForCode'.
	customRuleGenerator inputCode: inputCode.
	customRuleGenerator outputCode: 'outputCode'.
	methodString := customRuleGenerator ruleInitializationMethod.
	self assert:
		((RBParser parseMethod: methodString) isKindOf: RBMethodNode).
	self assert: (methodString includesSubstring: 'super initialize.').
	self assert: (methodString includesSubstring: 'replaceWithCode').
	self assert: (methodString includesSubstring: 'searchForCode').
	self assert: (methodString includesSubstring:
			 'aPackage includesSubstring: ''''Collection''''').
	self assert: (methodString includesSubstring: 'outputCode').
	self assert: (methodString includesSubstring: 'self replace:')
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testRuleNameMethod [

	| aRuleName ruleNameMethod |
	aRuleName := 'This is a name'.
	ruleNameMethod := customRuleGenerator ruleNameMethod: aRuleName.
	self assert: (ruleNameMethod includesSubstring: '^').
	self assert:
		((RBParser parseMethod: ruleNameMethod) isKindOf: RBMethodNode).
	self assert:
		(ruleNameMethod includesSubstring: '''' , aRuleName , '''')
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testRuleSuccessfullyCreatedAlert [

	| alert |
	alert := customRuleGenerator ruleSuccessfullyCreatedAlert.
	self assert: (alert isMemberOf: MorphicUIManager)
]

{ #category : #tests }
RTCustomRuleGeneratorTest >> testSearchFor [

	customRuleGenerator searchFor: 'searchForCode'.
	self assert: customRuleGenerator searchFor equals: 'searchForCode'
]
