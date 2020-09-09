"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTRemoveAssigmentWithoutEffect,
	#superclass : #RBTransformationRule,
	#category : #'CustomRewriteRules-Examples'
}

{ #category : #initialization }
RTRemoveAssigmentWithoutEffect >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`var := `var'.
	replaceWithPattern := ''.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
