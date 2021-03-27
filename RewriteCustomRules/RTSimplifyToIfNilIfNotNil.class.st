"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTSimplifyToIfNilIfNotNil,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTSimplifyToIfNilIfNotNil >> initialize [

	super initialize.
	lhs := '`@receiver isNil
	ifTrue: `@arg
	ifFalse: `@arg2'.
	rhs := '`@receiver ifNil: `@arg ifNotNil: `@arg2'.
	inputCode := 'aCollection isNil
	ifTrue: [ aCollection := OrderedCollection new ]
	ifFalse: [ aCollection select: #isDigit ]'.
	outputCode := 'aCollection
	ifNil: [ aCollection := OrderedCollection new ]
	ifNotNil: [ aCollection select: #isDigit ]'.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTSimplifyToIfNilIfNotNil >> isDemoRule [

	^ true
]
