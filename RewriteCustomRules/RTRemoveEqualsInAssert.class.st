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

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver assert: `@arg equals: true'.
	replaceWithPattern := '`@receiver assert: `@arg'.
	self replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTRemoveEqualsInAssert >> isDemoRule [

	^ true
]
