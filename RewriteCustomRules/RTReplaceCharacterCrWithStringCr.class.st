"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTReplaceCharacterCrWithStringCr,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTReplaceCharacterCrWithStringCr >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := 'Character cr asString'.
	replaceWithPattern := 'String cr'.
	inputCode := ''.
	outputCode := ''.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTReplaceCharacterCrWithStringCr >> isDemoRule [

	^ true
]
