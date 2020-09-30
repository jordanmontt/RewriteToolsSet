"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTRemoveAssigmentWithoutEffect,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTRemoveAssigmentWithoutEffect >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '`var := `var'.
	replaceWithPattern := ''.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTRemoveAssigmentWithoutEffect >> isDemoRule [

	^ true
]
