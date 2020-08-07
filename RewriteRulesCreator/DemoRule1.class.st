"
I am a demo rewrite rule.
"
Class {
	#name : #DemoRule1,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteRulesCreator-Demo'
}

{ #category : #initialization }
DemoRule1 >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`variable1 isNil
	ifTrue: `@block1.
`.Statement1'.
	replaceWithPattern := '`variable1 ifNil: `@block1.
`.Statement1'.
	input := ''.
	output := ''.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #accessing }
DemoRule1 >> someMethod [
	self isNil ifTrue: [ ^ true ].
	super size
]
