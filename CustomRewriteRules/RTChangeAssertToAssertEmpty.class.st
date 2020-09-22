"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTChangeAssertToAssertEmpty,
	#superclass : #RBCustomTransformationRule,
	#category : #'CustomRewriteRules-Examples'
}

{ #category : #initialization }
RTChangeAssertToAssertEmpty >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver assert: `@arg isEmpty'.
	replaceWithPattern := '`@receiver assertEmpty: `@arg'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
