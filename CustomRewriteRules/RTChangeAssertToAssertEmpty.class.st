"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTChangeAssertToAssertEmpty,
	#superclass : #RBTransformationRule,
	#category : #'CustomRewriteRules-Demo'
}

{ #category : #initialization }
RTChangeAssertToAssertEmpty >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver assert: `@arg isEmpty'.
	replaceWithPattern := '`@receiver assertEmpty: `@arg'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
