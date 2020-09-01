"
I am a demo rewrite rule.
"
Class {
	#name : #DefaultRule,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteRulesCreator-DefaultRule'
}

{ #category : #initialization }
DefaultRule >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@expression ifTrue: [ `@codeBlock ]'.
	replaceWithPattern := '`@expression ifFalse: [ ^ self ].
`@codeBlock'.
	input := ''.
	output := ''.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
