"
I am a demo rewrite rule.
"
Class {
	#name : #DemoRule2,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteRulesCreator-Demo'
}

{ #category : #initialization }
DemoRule2 >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`variable1 isNil
	ifTrue: `@block1.
`.@Statement1'.
	replaceWithPattern := '`variable1 ifNil: `@block1.
`.@Statement1'.
	input := ''.
	output := ''.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #accessing }
DemoRule2 >> someMethod [

	self isNil ifTrue: [ ^ true ].
	super size
]
