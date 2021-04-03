"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTReplaceCollectWithFlatCollect,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-Examples'
}

{ #category : #initialization }
RTReplaceCollectWithFlatCollect >> initialize [

	super initialize.
	lhs := '(`@receiver collect: `@arg) flattened'.
	rhs := '`@receiver flatCollect: `@arg'.
	inputCode := '(RBBrowserEnvironment default packages collect: #classes) flattened'.
	outputCode := 'RBBrowserEnvironment default packages flatCollect: #classes'.
	self replace: lhs with: rhs
]

{ #category : #testing }
RTReplaceCollectWithFlatCollect >> isDemoRule [

	^ true
]
