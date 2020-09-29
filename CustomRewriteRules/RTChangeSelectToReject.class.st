"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTChangeSelectToReject,
	#superclass : #RBCustomTransformationRule,
	#category : #'CustomRewriteRules-Examples'
}

{ #category : #initialization }
RTChangeSelectToReject >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver select: [ :`each | 
	| `@temps |
	``@.Statements.
	``@object not ]'.
	replaceWithPattern := '`@receiver reject: [ :`each | 
	| `@temps |
	``@.Statements.
	``@object ]'.
	inputCode := 'RBPackageEnvironment new packages select: [ :aPackage | 
	(aPackage includesSubstring: ''Collection'') not ]'.
	outputCode := 'RBPackageEnvironment new packages reject: [ :aPackage | 
	aPackage includesSubstring: ''Collection'' ]'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
