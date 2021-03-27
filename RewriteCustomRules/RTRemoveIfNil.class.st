"
I am a demo Rewrite Rule.
"
Class {
	#name : #RTRemoveIfNil,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTRemoveIfNil >> initialize [

	super initialize.
	lhs := '`@receiver ifNil: [ nil ] ifNotNil: `@arg'.
	rhs := '`@receiver ifNotNil: `@arg'.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTRemoveIfNil >> isDemoRule [

	^ true
]
