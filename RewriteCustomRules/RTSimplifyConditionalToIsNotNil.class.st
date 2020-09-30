"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTSimplifyConditionalToIsNotNil,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTSimplifyConditionalToIsNotNil >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver ifNil: [ false ] ifNotNil: [ true ]'.
	replaceWithPattern := '`@receiver isNotNil'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTSimplifyConditionalToIsNotNil >> isDemoRule [

	^ true
]
