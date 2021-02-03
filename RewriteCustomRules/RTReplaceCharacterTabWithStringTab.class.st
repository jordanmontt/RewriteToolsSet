"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTReplaceCharacterTabWithStringTab,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTReplaceCharacterTabWithStringTab >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := 'Character tab asString'.
	replaceWithPattern := 'String tab'.
	inputCode := ''.
	outputCode := ''.
	self replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTReplaceCharacterTabWithStringTab >> isDemoRule [

	^ true
]
