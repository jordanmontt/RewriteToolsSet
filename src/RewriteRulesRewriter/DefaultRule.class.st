"
I am a demo rewrite rule.
"
Class {
	#name : #DefaultRule,
	#superclass : #RTRuleHolder,
	#category : #'RewriteRulesRewriter-DefaultRule'
}

{ #category : #initialization }
DefaultRule >> initialize [

	super initialize.
	
	lhs := '(`@receiver collect: `@arg) flattened'.
	
	rhs := '`@receiver flatCollect: `@arg'.
	
	inputCode := '(RBBrowserEnvironment default packages collect: #classes) flattened'.
	
	outputCode := 'RBBrowserEnvironment default packages flatCollect: #classes'.
	
	isDemoRule := true
]
