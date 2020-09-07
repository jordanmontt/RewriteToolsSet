"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTChangeDenyToDenyEmpty,
	#superclass : #RBTransformationRule,
	#category : #'CustomRewriteRules-Demo'
}

{ #category : #initialization }
RTChangeDenyToDenyEmpty >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver deny: `@arg isEmpty'.
	replaceWithPattern := '`@receiver denyEmpty: `@arg'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
