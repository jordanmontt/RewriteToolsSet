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
		'replaceWith'
	],
	#category : #'RewriteToolCustomRules-Core'
}

{ #category : #defaults }
CustomRuleGenerator >> classNotCreatedAlert [
	UIManager default alert: 'The name you enter is invalid. Please try again.' title: 'Alert'
]

{ #category : #defaults }
CustomRuleGenerator >> generate: aClassName forProtocol: aPackageProtocol [
	^ RBCustomTransformationRule
		subclass: aClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'RewriteToolCustomRules-' , aPackageProtocol
]

{ #category : #api }
CustomRuleGenerator >> generateCustomRewriteRule [
	| ruleName packageProtocol |
	ruleName := self inputClassName.
	packageProtocol := self inputPackageProtocol.
	((self nameIsValid: ruleName)
		and: [ self nameIsValid: packageProtocol ])
		ifTrue: [ | class |
			class := self generate: ruleName forProtocol: packageProtocol.
			class
				compile: self getRuleInitializationMethod
				classified: 'initialization' ]
		ifFalse: [ self classNotCreatedAlert ]
]

{ #category : #defaults }
CustomRuleGenerator >> getRuleInitializationMethod [
	^ 'initialize
	super initialize.
	self searchFor: ''' , searchFor
		,
			'''.
	self replaceWith: ''' , replaceWith
		,
			'''.
	self input: ''' , input
		,
			'''.
	self output: ''' , output
		,
			'''.
	self rewriteRule
		replace: searchFor
		with: replaceWith'
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
	^ UIManager default
		request: 'Name of the rewrite rule class: '
		initialAnswer: ''
]

{ #category : #defaults }
CustomRuleGenerator >> inputPackageProtocol [
	^ UIManager default
		request: 'Name of the protocol of the rewrite rule package: '
		initialAnswer: 'Custom'
]

{ #category : #testing }
CustomRuleGenerator >> nameIsValid: aName [
	^ aName isNotNil
		and: [ aName ~= ''
				and: [ aName first isUppercase and: [ aName ~= 'Core' ] ] ]
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
CustomRuleGenerator >> searchFor: anObject [
	searchFor := anObject
]
