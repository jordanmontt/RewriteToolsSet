"
I am in charge of saving the RewriteRules. I receive the custom rule as plain text and save it in form of a class. 
"
Class {
	#name : #CustomRuleGenerator,
	#superclass : #Object,
	#instVars : [
		'input',
		'output',
		'searchFor',
		'replaceWith',
		'ruleName',
		'packageName'
	],
	#category : #'RewriteCustomRules-Core'
}

{ #category : #testing }
CustomRuleGenerator >> areRuleAndPackageNamesValid [
	^ packageName isNotNil
		and: [ packageName isValidGlobalName
				and: [ ruleName isNotNil and: [ ruleName isValidGlobalName ] ] ]
]

{ #category : #defaults }
CustomRuleGenerator >> classNotCreatedAlert [
	self flag: 'should not use'.
	UIManager default
		alert: 'The name you enter is invalid. Please try again.'
		title: 'Alert'
]

{ #category : #api }
CustomRuleGenerator >> generateCustomRewriteRule [
	| ruleAsClass |
	self flag: 'should not use'.
	ruleName := self inputClassName.
	packageName := self inputPackageProtocol.
	self areRuleAndPackageNamesValid
		ifFalse: [ self classNotCreatedAlert.
			^ self ].
	ruleAsClass := RBCustomTransformationRule
		subclass: ruleName
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'RewriteToolCustomRules-' , packageName.
	ruleAsClass
		compile: self ruleInitializationMethod
		classified: 'initialization'
]

{ #category : #api }
CustomRuleGenerator >> generateRule: aRuleName forPackage: aPackageName [
	| ruleAsClass |
	self areRuleAndPackageNamesValid
		ifFalse: [ ^ false ].
	ruleAsClass := RBCustomTransformationRule
		subclass: aRuleName
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'RewriteToolCustomRules-' , aPackageName.
	ruleAsClass
		compile: self ruleInitializationMethod
		classified: 'initialization'.
	^ true
]

{ #category : #initialization }
CustomRuleGenerator >> initialize [
	super initialize.
	input := ''.
	output := ''.
]

{ #category : #accessing }
CustomRuleGenerator >> input: anObject [
	input := anObject
]

{ #category : #defaults }
CustomRuleGenerator >> inputClassName [
	self flag: 'should not use'.
	^ UIManager default
		request: 'Name of the rewrite rule class: '
		initialAnswer: ''
]

{ #category : #defaults }
CustomRuleGenerator >> inputPackageProtocol [
	self flag: 'should not use'.
	^ UIManager default
		request: 'Name of the protocol of the rewrite rule package: '
		initialAnswer: 'Custom'
]

{ #category : #accessing }
CustomRuleGenerator >> output: anObject [
	output := anObject
]

{ #category : #accessing }
CustomRuleGenerator >> replaceWith: anObject [
	replaceWith := anObject
]

{ #category : #accessing }
CustomRuleGenerator >> ruleInitializationMethod [
	^ 'initialize
	super initialize.
	searchFor := ''' , searchFor
		,
			'''.
	replaceWith := ''' , replaceWith
		,
			'''.
	input := ''' , input
		,
			'''.
	output := ''' , output
		,
			'''.
	rewriteRule replace: searchFor with: replaceWith'
]

{ #category : #accessing }
CustomRuleGenerator >> searchFor: anObject [
	searchFor := anObject
]
