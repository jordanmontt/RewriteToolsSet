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
	searchForPattern := '`@receiver isNil ifTrue: `@arg ifFalse: `@arg2'.
	replaceWithPattern := '`@receiver ifNil: `@arg ifNotNil: `@arg2'.
	inputCode := 'aCollection isNil
	ifTrue: [ aCollection := OrderedCollection new ]
	ifFalse: [ aCollection reject: #isLetter ]'.
	outputCode := 'aCollection
	ifNil: [ aCollection := OrderedCollection new ]
	ifNotNil: [ aCollection reject: #isLetter ]'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
