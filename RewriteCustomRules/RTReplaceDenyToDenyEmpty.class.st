"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTReplaceDenyToDenyEmpty,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTReplaceDenyToDenyEmpty >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver deny: `@arg isEmpty'.
	replaceWithPattern := '`@receiver denyEmpty: `@arg'.
	self replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTReplaceDenyToDenyEmpty >> isDemoRule [

	^ true
]
