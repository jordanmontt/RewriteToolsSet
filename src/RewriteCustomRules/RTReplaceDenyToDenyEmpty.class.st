"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTReplaceDenyToDenyEmpty,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTReplaceDenyToDenyEmpty >> initialize [

	super initialize.
	lhs := '`@receiver deny: `@arg isEmpty'.
	rhs := '`@receiver denyEmpty: `@arg'.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTReplaceDenyToDenyEmpty >> isDemoRule [

	^ true
]
