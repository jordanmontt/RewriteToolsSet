Class {
	#name : #RTSimplifyConditionalToIsNotEmpty,
	#superclass : #RBCustomTransformationRule,
	#category : #'CustomRewriteRules-Examples'
}

{ #category : #initialization }
RTSimplifyConditionalToIsNotEmpty >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver ifEmpty: [ false ] ifNotEmpty: [ true ]'.
	replaceWithPattern := '`@receiver isNotEmpty'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTSimplifyConditionalToIsNotEmpty >> isDemoRule [

	^ true
]
