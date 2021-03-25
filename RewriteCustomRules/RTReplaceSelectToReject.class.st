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

	super initialize.
	lhs := '`@receiver select: [ :`each | 
	| `@temps |
	``@.Statements.
	``@object not ]'.
	rhs := '`@receiver reject: [ :`each | 
	| `@temps |
	``@.Statements.
	``@object ]'.
	inputCode := 'RBPackageEnvironment new packages select: [ :aPackage | 
	(aPackage includesSubstring: ''Collection'') not ]'.
	outputCode := 'RBPackageEnvironment new packages reject: [ :aPackage | 
	aPackage includesSubstring: ''Collection'' ]'.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTReplaceSelectToReject >> isDemoRule [

	^ true
]
