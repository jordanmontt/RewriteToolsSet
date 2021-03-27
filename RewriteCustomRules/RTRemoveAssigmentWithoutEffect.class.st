"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTRemoveAssigmentWithoutEffect,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTRemoveAssigmentWithoutEffect >> initialize [

	super initialize.
	lhs := '`var := `var'.
	rhs := ''.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTRemoveAssigmentWithoutEffect >> isDemoRule [

	^ true
]
