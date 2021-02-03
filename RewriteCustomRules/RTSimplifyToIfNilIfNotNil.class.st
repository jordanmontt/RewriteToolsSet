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
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver isNil
	ifTrue: `@arg
	ifFalse: `@arg2'.
	replaceWithPattern := '`@receiver ifNil: `@arg ifNotNil: `@arg2'.
	inputCode := 'aCollection isNil
	ifTrue: [ aCollection := OrderedCollection new ]
	ifFalse: [ aCollection select: #isDigit ]'.
	outputCode := 'aCollection
	ifNil: [ aCollection := OrderedCollection new ]
	ifNotNil: [ aCollection select: #isDigit ]'.
	self replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTSimplifyToIfNilIfNotNil >> isDemoRule [

	^ true
]
