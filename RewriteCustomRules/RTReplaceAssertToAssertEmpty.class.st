"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTReplaceAssertToAssertEmpty,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTReplaceAssertToAssertEmpty >> initialize [

	super initialize.
	lhs := '`@receiver assert: `@arg isEmpty'.
	rhs := '`@receiver assertEmpty: `@arg'.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTReplaceAssertToAssertEmpty >> isDemoRule [

	^ true
]
