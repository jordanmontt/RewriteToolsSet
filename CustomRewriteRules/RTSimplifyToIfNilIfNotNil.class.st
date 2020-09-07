"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTSimplifyToIfNilIfNotNil,
	#superclass : #RBTransformationRule,
	#category : #'CustomRewriteRules-Demo'
}

{ #category : #initialization }
RTSimplifyToIfNilIfNotNil >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver isNil ifTrue: `@arg ifFalse: `@arg2'.
	replaceWithPattern := '`@receiver ifNil: `@arg ifNotNil: `@arg2'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
