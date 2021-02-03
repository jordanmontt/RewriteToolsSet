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

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver ifNil: [ nil ] ifNotNil: `@arg'.
	replaceWithPattern := '`@receiver ifNotNil: `@arg'.
	self replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTRemoveIfNil >> isDemoRule [

	^ true
]
