"
I am a demo rewrite rule.
"
Class {
	#name : #DefaultRule,
	#superclass : #RBTransformationRule,
	#category : #'RewriteRulesCreator-DefaultRule'
}

{ #category : #initialization }
DefaultRule >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver isNil ifTrue: `@arg ifFalse: `@arg2'.
	replaceWithPattern := '`@receiver ifNil: `@arg ifNotNil: `@arg2'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
