"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTReplaceCharacterTabWithStringTab,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTReplaceCharacterTabWithStringTab >> initialize [

	super initialize.
	lhs := 'Character tab asString'.
	rhs := 'String tab'.
	inputCode := ''.
	outputCode := ''.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTReplaceCharacterTabWithStringTab >> isDemoRule [

	^ true
]
