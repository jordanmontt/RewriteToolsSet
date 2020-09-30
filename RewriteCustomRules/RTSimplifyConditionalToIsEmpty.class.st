"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTSimplifyConditionalToIsEmpty,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTSimplifyConditionalToIsEmpty >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver ifEmpty: [ true ] ifNotEmpty: [ false ]'.
	replaceWithPattern := '`@receiver isEmpty'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTSimplifyConditionalToIsEmpty >> isDemoRule [

	^ true
]
