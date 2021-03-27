"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTSimplifyConditionalToIsNotNil,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTSimplifyConditionalToIsNotNil >> initialize [

	super initialize.
	lhs := '`@receiver ifNil: [ false ] ifNotNil: [ true ]'.
	rhs  := '`@receiver isNotNil'.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTSimplifyConditionalToIsNotNil >> isDemoRule [

	^ true
]
