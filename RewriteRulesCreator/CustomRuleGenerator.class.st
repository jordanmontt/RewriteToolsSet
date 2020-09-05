"
I store custom Rewrite Rules as a subclass of `RBTransformationRule`. These custom rules are the ones that you store using the RewriteBasicEditorPresenter and the ones that you can load using the RewriteRuleLoaderPresenter.

Before you save the rule, you must set the value of my instance variables: searchFor and replaceWith.

An example of use:
`CustomRuleGenerator new
		  searchFor: '';
		  replaceWith: '';
		  generateRule: 'ACustomRewriteRule' forPackage: 'Custom'`
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
	searchFor isNil | replaceWith isNil ifTrue: [ 
		Exception signal:
			'You must set the values of searchFor and replaceWith with a pattern code.'.
		^ nil ].
	aRuleClassName isValidGlobalName & aPackageName isEmptyOrNil not 
		ifFalse: [ ^ nil ].
	fullPackageName := 'CustomRewriteRules-' , aPackageName.
	ruleAsClass := RBTransformationRule
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
