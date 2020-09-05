"
I am a Demo Rewrite Rule.
"
Class {
	#name : #DemoRule2,
	#superclass : #RBTransformationRule,
	#category : #'CustomRewriteRules-Demo'
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
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #defaults }
DemoRule2 >> someMethod [

	self isNil ifTrue: [ ^ true ].
	super size
]
