"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTSimplifyConditionalToIsEmpty,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTSimplifyConditionalToIsEmpty >> initialize [

	super initialize.
	lhs := '`@receiver ifEmpty: [ true ] ifNotEmpty: [ false ]'.
	rhs := '`@receiver isEmpty'.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTSimplifyConditionalToIsEmpty >> isDemoRule [

	^ true
]
