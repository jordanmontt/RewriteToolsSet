"
I am default rewrite demo rule
"
Class {
	#name : #DefaultBuilderRule,
	#superclass : #RTRuleHolder,
	#category : #'RewriteRulesCreator-DefaultRule'
}

{ #category : #initialization }
DefaultBuilderRule >> initialize [

	super initialize.
	lhs := 'RBBrowserEnvironment new packages select: [ :aPackage | 
	| ``@temporaries1 |
	"""Tips:
	1. Highlight `packageName := aPackage name.` right-click it and select the option ''Abstract statement''.
	2. Abstract `RBBrowserEnvironment new packages` as an object."""
	packageName := aPackage name.
	``@conditional not ]'.
	rhs := 'RBBrowserEnvironment new packages reject: [ :aPackage | 
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
	isDemoRule := true
]
