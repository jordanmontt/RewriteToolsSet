"
I am a demo rewrite rule.
"
Class {
	#name : #DemoRule3,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteRulesCreator-Demo'
}

{ #category : #accessing }
DemoRule3 >> fooMethod [
	true not
		ifTrue: [ ^ 1 + 1 ]
		ifFalse: [ ^ 1 + 0 ]
]

{ #category : #initialization }
DemoRule3 >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := 'true not
		ifTrue: `@block1
		ifFalse: `@block2'.
	replaceWithPattern := 'false
		ifTrue: `@block1
		ifFalse: `@block2'.
	input := ''.
	output := ''.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
