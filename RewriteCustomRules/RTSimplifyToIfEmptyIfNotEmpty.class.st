"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTSimplifyToIfEmptyIfNotEmpty,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTSimplifyToIfEmptyIfNotEmpty >> initialize [

	super initialize.
	lhs := '`@receiver isEmpty ifTrue: `@arg ifFalse: `@arg2'.
	rhs := '`@receiver ifEmpty: `@arg ifNotEmpty: `@arg2'.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTSimplifyToIfEmptyIfNotEmpty >> isDemoRule [

	^ true
]
