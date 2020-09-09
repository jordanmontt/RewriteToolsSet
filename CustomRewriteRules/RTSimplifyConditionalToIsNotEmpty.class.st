Class {
	#name : #RTSimplifyConditionalToIsNotEmpty,
	#superclass : #RBTransformationRule,
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
