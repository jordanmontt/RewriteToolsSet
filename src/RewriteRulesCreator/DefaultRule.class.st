"
I am a demo rewrite rule.
"
Class {
	#name : #DefaultRule,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteRulesCreator-DefaultRule'
}

{ #category : #initialization }
DefaultRule >> initialize [

	super initialize.
	lhs := '(`@receiver collect: `@arg) flattened'.
	rhs := '`@receiver flatCollect: `@arg'.
	inputCode := '(RBBrowserEnvironment default packages collect: #classes) flattened'.
	outputCode := 'RBBrowserEnvironment default packages flatCollect: #classes'.
	self replace: lhs with: rhs
]

{ #category : #testing }
DefaultRule >> isDemoRule [

	^ true
]

{ #category : #accessing }
DefaultRule >> name [

	^ 'The rewrite rule that is loaded in RewriteBasicEditorPresenter.'
]
