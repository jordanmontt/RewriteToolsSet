"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTReplaceAssertToAssertEmpty,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTReplaceAssertToAssertEmpty >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver assert: `@arg isEmpty'.
	replaceWithPattern := '`@receiver assertEmpty: `@arg'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTReplaceAssertToAssertEmpty >> isDemoRule [

	^ true
]
