"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTSimplifyToIfEmptyIfNotEmpty,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTSimplifyToIfEmptyIfNotEmpty >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver isEmpty ifTrue: `@arg ifFalse: `@arg2'.
	replaceWithPattern := '`@receiver ifEmpty: `@arg ifNotEmpty: `@arg2'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTSimplifyToIfEmptyIfNotEmpty >> isDemoRule [

	^ true
]
