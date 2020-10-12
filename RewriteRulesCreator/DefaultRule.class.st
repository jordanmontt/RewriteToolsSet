"
I am a demo rewrite rule.
"
Class {
	#name : #DefaultRule,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteRulesCreator-DefaultRule'
}

{ #category : #initialization }
DefaultRule >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '(`@receiver collect: `@arg) flattened'.
	replaceWithPattern := '`@receiver flatCollect: `@arg'.
	inputCode := '(RBBrowserEnvironment default packages collect: #classes) flattened'.
	outputCode := 'RBBrowserEnvironment default packages flatCollect: #classes'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
DefaultRule >> isDemoRule [

	^ true
]
