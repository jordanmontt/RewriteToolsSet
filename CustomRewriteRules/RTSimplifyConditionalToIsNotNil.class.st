"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTSimplifyConditionalToIsNotNil,
	#superclass : #RBTransformationRule,
	#category : #'CustomRewriteRules-Demo'
}

{ #category : #initialization }
RTSimplifyConditionalToIsNotNil >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`@receiver ifNil: [ false ] ifNotNil: [ true ]'.
	replaceWithPattern := '`@receiver isNotNil'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
