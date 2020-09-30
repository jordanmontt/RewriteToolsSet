"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTSimplifyToIfNilIfNotNil,
	#superclass : #RBCustomTransformationRule,
	#category : #'CustomRewriteRules-Examples'
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
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTSimplifyToIfNilIfNotNil >> isDemoRule [

	^ true
]
