"
I store custom Rewrite Rules as a subclass of `RBTransformationRule`. These custom rules are the ones that you store using the RewriteBasicEditorPresenter and the ones that you can load using the RewriteRuleLoaderPresenter.

Before you save the rule, you must set the value of my instance variables: searchFor and replaceWith.

An example of use:
` | ruleGenerator | 
ruleGenerator := CustomRuleGenerator new
		searchFor: '';
		replaceWith: ';
		inputCode: '';
		outputCode: ''.
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

{ #category : #accesing }
CustomRuleGenerator class >> getAllRules [

	^ RBCustomTransformationRule subclasses
]

{ #category : #accesing }
CustomRuleGenerator class >> getOnlyCustomRules [

	^ RBCustomTransformationRule subclasses reject: [ :rule | 
		  rule new isDemoRule ]
]

{ #category : #accesing }
CustomRuleGenerator class >> packageName [

	^ 'RewriteCustomRules'
]

{ #category : #defaults }
CustomRuleGenerator >> doubleSingleQuotes: aString [

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
	fullPackageName := self class packageName , '-' , aPackageName.
	ruleAsClass := RBCustomTransformationRule
		               subclass: aRuleClassName
		               instanceVariableNames: ''
		               classVariableNames: ''
		               package: fullPackageName.
	ruleAsClass
		compile: self ruleInitializationMethod
		classified: 'initialization'.
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

{ #category : #'api - initialization' }
CustomRuleGenerator >> inputCode: anObject [
	inputCode := anObject
]

{ #category : #alerts }
CustomRuleGenerator >> invalidRuleNameAlert [

	^ UIManager default inform:
		'The name(s) you entered is not a valid class name. Please try again.'
]

{ #category : #accessing }
CustomRuleGenerator >> outputCode [
	^ outputCode
]

{ #category : #'api - initialization' }
CustomRuleGenerator >> outputCode: anObject [
	outputCode := anObject
]

{ #category : #accessing }
CustomRuleGenerator >> replaceWith [

	^ replaceWith
]

{ #category : #'api - initialization' }
CustomRuleGenerator >> replaceWith: aString [

	replaceWith := aString
]

{ #category : #accessing }
CustomRuleGenerator >> ruleInitializationMethod [

	^ 'initialize
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := ''' , (self doubleSingleQuotes: searchFor) , '''.
	replaceWithPattern := ''' , (self doubleSingleQuotes: replaceWith) , '''.
	inputCode := ''' , (self doubleSingleQuotes: inputCode) , '''.
	outputCode := ''' , (self doubleSingleQuotes: outputCode) , '''.
	rewriteRule replace: searchForPattern with: replaceWithPattern'
]

{ #category : #alerts }
CustomRuleGenerator >> ruleSuccessfullyCreatedAlert [

	^ UIManager default inform: 'The rule was successfully created!'
]

{ #category : #accessing }
CustomRuleGenerator >> searchFor [

	^ searchFor
]

{ #category : #'api - initialization' }
CustomRuleGenerator >> searchFor: aString [

	searchFor := aString
]

{ #category : #api }
CustomRuleGenerator >> storeRule: aDefaultRuleName [

	"aDefaultRuleName is a name that will be written in the prompt. Can be a name, an empty string or nil."

	| ruleClassName packageName newlyGeneratedRule |
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
	newlyGeneratedRule := self
		                      generateRule: ruleClassName
		                      forPackage: packageName.
	self ruleSuccessfullyCreatedAlert.
	^ newlyGeneratedRule
]
