"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTRemoveEqualsInAssert,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTRemoveEqualsInAssert >> initialize [

	super initialize.
	lhs := '`@receiver assert: `@arg equals: true'.
	rhs := '`@receiver assert: `@arg'.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTRemoveEqualsInAssert >> isDemoRule [

	^ true
]
