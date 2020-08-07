"
I am a demo rewrite rule.
"
Class {
	#name : #DemoRule3,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteRulesCreator-Demo'
}

{ #category : #initialization }
DemoRule3 >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := 'true not
		ifTrue: [ ^ 1 + 1 ]
		ifFalse: [ ^ 1 + 0 ]'.
	replaceWithPattern := 'false
		ifTrue: [ ^ 1 + 1 ]
		ifFalse: [ ^ 1 + 0 ]'.
	input := ''.
	output := ''.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
