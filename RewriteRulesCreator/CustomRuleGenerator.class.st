"
I am in charge of saving the RewriteRules. I receive the custom rule as plain text and save it in form of a class. 
"
Class {
	#name : #CustomRuleGenerator,
	#superclass : #Object,
	#instVars : [
		'searchFor',
		'replaceWith'
	],
	#category : #'RewriteRulesCreator-Core'
}

{ #category : #api }
CustomRuleGenerator >> generateRule: aRuleClassName forPackage: aPackageName [

	| ruleAsClass fullPackageName |
	(aRuleClassName isValidGlobalName and: [ 
		 aPackageName isEmptyOrNil not ]) ifFalse: [ ^ nil ].
	fullPackageName := 'CustomRewriteRules'.
	aPackageName ifNotEmpty: [ 
		fullPackageName := fullPackageName , '-' , aPackageName ].
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

{ #category : #accessing }
CustomRuleGenerator >> replaceWith: anObject [
	replaceWith := anObject
]

{ #category : #accessing }
CustomRuleGenerator >> ruleInitializationMethod [

	^ 'initialize
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := ''' , searchFor , '''.
	replaceWithPattern := ''' , replaceWith , '''.
	rewriteRule replace: searchForPattern with: replaceWithPattern'
]

{ #category : #accessing }
CustomRuleGenerator >> searchFor: anObject [
	searchFor := anObject
]
