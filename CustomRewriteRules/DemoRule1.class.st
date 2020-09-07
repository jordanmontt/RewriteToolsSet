"
I am a Demo Rewrite Rule.
"
Class {
	#name : #DemoRule1,
	#superclass : #RBTransformationRule,
	#category : #'CustomRewriteRules-Demo'
}

{ #category : #initialization }
DemoRule1 >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver ifEmpty: [ true ] ifNotEmpty: [ false ]'.
	replaceWithPattern := '`@receiver isEmpty'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
