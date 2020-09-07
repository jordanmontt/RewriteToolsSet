"
I am a Demo Rewrite Rule.
"
Class {
	#name : #DemoRule3,
	#superclass : #RBTransformationRule,
	#category : #'CustomRewriteRules-Demo'
}

{ #category : #initialization }
DemoRule3 >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver assert: `@arg equals: true'.
	replaceWithPattern := '`@receiver assert: `@arg'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
