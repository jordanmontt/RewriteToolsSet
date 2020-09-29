"
I store custom Rewrite Rules as a subclass of `RBTransformationRule`. These custom rules are the ones that you store using the RewriteBasicEditorPresenter and the ones that you can load using the RewriteRuleLoaderPresenter.

Before you save the rule, you must set the value of my instance variables: searchFor and replaceWith.

An example of use:
` | ruleGenerator | 
ruleGenerator := CustomRuleGenerator new
		searchFor: '';
		replaceWith: ''.
ruleGenerator storeRule: aDefaultRuleName`
(The aDefaultRuleName can be an empty string, nil, or a rule name)
"
Class {
	#name : #CustomRuleGenerator,
	#superclass : #Object,
	#instVars : [
		'searchFor',
		'replaceWith',
		'inputCode',
		'outputCode'
	],
	#category : #'RewriteRulesCreator-Core'
}

{ #category : #defaults }
CustomRuleGenerator >> doubleQuotes: aString [

	| aStream |
	aStream := String new writeStream.
	aString do: [ :charac | 
		charac = $' ifTrue: [ aStream nextPut: charac ].
		aStream nextPut: charac ].
	^ aStream contents
]

{ #category : #private }
CustomRuleGenerator >> generateRule: aRuleClassName forPackage: aPackageName [

	| ruleAsClass fullPackageName |
	fullPackageName := 'CustomRewriteRules-' , aPackageName.
	ruleAsClass := RBCustomTransformationRule
		               subclass: aRuleClassName
		               instanceVariableNames: ''
		               classVariableNames: ''
		               package: fullPackageName.
	ruleAsClass
		compile: self ruleInitializationMethod
		classified: 'initialization'.
	self ruleSuccessfullyCreatedAlert.
	^ ruleAsClass
]

{ #category : #initialization }
CustomRuleGenerator >> initialize [

	super initialize.
	inputCode := ''.
	outputCode := ''
]

{ #category : #accessing }
CustomRuleGenerator >> inputCode [
	^ inputCode
]

{ #category : #accessing }
CustomRuleGenerator >> inputCode: anObject [
	inputCode := anObject
]

{ #category : #alerts }
CustomRuleGenerator >> invalidRuleNameAlert [

	UIManager default inform:
		'The name(s) you entered is not a valid class name. Please try again.'
]

{ #category : #accessing }
CustomRuleGenerator >> outputCode [
	^ outputCode
]

{ #category : #accessing }
CustomRuleGenerator >> outputCode: anObject [
	outputCode := anObject
]

{ #category : #accessing }
CustomRuleGenerator >> replaceWith [

	^ replaceWith
]

{ #category : #accessing }
CustomRuleGenerator >> replaceWith: aString [

	replaceWith := aString
]

{ #category : #accessing }
CustomRuleGenerator >> ruleInitializationMethod [

	^ 'initialize
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := ''' , (self doubleQuotes: searchFor) , '''.
	replaceWithPattern := ''' , (self doubleQuotes: replaceWith) , '''.
	inputCode := ''' , (self doubleQuotes: inputCode) , '''.
	outputCode := ''' , (self doubleQuotes: outputCode) , '''.
	rewriteRule replace: searchForPattern with: replaceWithPattern'
]

{ #category : #alerts }
CustomRuleGenerator >> ruleSuccessfullyCreatedAlert [

	UIManager default inform: 'The rule was successfully created!'
]

{ #category : #accessing }
CustomRuleGenerator >> searchFor [

	^ searchFor
]

{ #category : #accessing }
CustomRuleGenerator >> searchFor: aString [

	searchFor := aString
]

{ #category : #api }
CustomRuleGenerator >> storeRule: aDefaultRuleName [

	| ruleClassName packageName |
	searchFor isNil | replaceWith isNil ifTrue: [ 
		Exception signal:
			'You must set the values of searchFor and replaceWith with a pattern code.'.
		^ nil ].
	ruleClassName := UIManager default
		                 request: 'Name of the Rule class: '
		                 initialAnswer: aDefaultRuleName.
	"If the user pressed the cancel button."
	ruleClassName ifNil: [ ^ nil ].
	packageName := UIManager default
		               request: 'Name of the Package: '
		               initialAnswer: 'Custom'.
	"If the user pressed the cancel button."
	packageName ifNil: [ ^ nil ].
	ruleClassName isValidGlobalName & packageName isNotEmpty ifFalse: [ 
		self invalidRuleNameAlert.
		^ nil ].
	^ self generateRule: ruleClassName forPackage: packageName
]
