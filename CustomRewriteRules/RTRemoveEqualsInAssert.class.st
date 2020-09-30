"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTRemoveEqualsInAssert,
	#superclass : #RBCustomTransformationRule,
	#category : #'CustomRewriteRules-Examples'
}

{ #category : #initialization }
RTRemoveEqualsInAssert >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver assert: `@arg equals: true'.
	replaceWithPattern := '`@receiver assert: `@arg'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTRemoveEqualsInAssert >> isDemoRule [

	^ true
]
