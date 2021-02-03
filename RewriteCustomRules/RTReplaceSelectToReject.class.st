"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTReplaceSelectToReject,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTReplaceSelectToReject >> initialize [
	
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
	self replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTReplaceSelectToReject >> isDemoRule [

	^ true
]
