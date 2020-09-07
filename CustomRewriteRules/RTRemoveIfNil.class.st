"
I am a demo Rewrite Rule.
"
Class {
	#name : #RTRemoveIfNil,
	#superclass : #RBTransformationRule,
	#category : #'CustomRewriteRules-Demo'
}

{ #category : #initialization }
RTRemoveIfNil >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver ifNil: [ nil ] ifNotNil: `@arg'.
	replaceWithPattern := '`@receiver ifNotNil: `@arg'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
