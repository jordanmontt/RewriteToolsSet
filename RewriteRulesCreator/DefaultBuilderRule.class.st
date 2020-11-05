"
I am default rewrite demo rule
"
Class {
	#name : #DefaultBuilderRule,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteRulesCreator-DefaultRule'
}

{ #category : #initialization }
DefaultBuilderRule >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := 'RBBrowserEnvironment new packages select: [ :aPackage | 
	| ``@temporaries1 |
	"""Tips:
	1. Highlight `RBBrowserEnvironment new packages` right-click it and select the option ''Abstract object''.
	2. Abstract `packageName := aPackage name.` as a statement."""
	packageName := aPackage name.
	``@conditional not ]'.
	replaceWithPattern := 'RBBrowserEnvironment new packages reject: [ :aPackage | 
	| ``@temporaries1 |
	packageName := aPackage name.
	``@conditional ]'.
	inputCode := 'RBBrowserEnvironment new packages select: [ :aPackage | 
	| packageName |
	packageName := aPackage name.
	(packageName includesSubstring: ''Collection'') not ]'.
	outputCode := 'RBBrowserEnvironment new packages reject: [ :aPackage | 
	| packageName |
	packageName := aPackage name.
	packageName includesSubstring: ''Collection'' ]'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]

{ #category : #testing }
DefaultBuilderRule >> isDemoRule [

	^ true
]
