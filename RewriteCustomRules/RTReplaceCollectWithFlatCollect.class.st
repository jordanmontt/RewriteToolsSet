"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTReplaceCollectWithFlatCollect,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTReplaceCollectWithFlatCollect >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '(`@receiver collect: `@arg) flattened'.
	replaceWithPattern := '`@receiver flatCollect: `@arg'.
	inputCode := ''.
	outputCode := ''.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
RTReplaceCollectWithFlatCollect >> isDemoRule [

	^ true
]
