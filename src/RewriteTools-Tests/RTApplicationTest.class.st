"
A RTApplicationTest is a test class for testing the behavior of RTApplication
"
Class {
	#name : #RTApplicationTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'RewriteTools-Tests'
}

{ #category : #running }
RTApplicationTest >> setUp [

	super setUp.

	application := RTApplication new
]

{ #category : #running }
RTApplicationTest >> testStartExpressionFinder [

	| window |
	window := application startExpressionFinder.
	self assert: window isBuilt.
	self assert: window presenter application equals: application.
	
	window close
]

{ #category : #running }
RTApplicationTest >> testStartHelpBrowser [

	| window |
	window := application startHelpBrowser.
	self assert: window isBuilt.
	self assert: window presenter application equals: application.
	
	window close
]

{ #category : #running }
RTApplicationTest >> testStartMatchTool [

	| window |
	window := application startMatchTool.
	self assert: window isBuilt.
	self assert: window presenter application equals: application.
	
	window close
]

{ #category : #running }
RTApplicationTest >> testStartRuleEditor [

	| window |
	window := application startRuleEditor.
	self assert: window isBuilt.
	self assert: window presenter application equals: application.
	
	window close
]

{ #category : #running }
RTApplicationTest >> testStartRuleLoader [

	| window |
	window := application startRuleLoader.
	self assert: window isBuilt.
	self assert: window presenter application equals: application.
	
	window close
]

{ #category : #running }
RTApplicationTest >> testStartTransformer [

	| window |
	window := application startTransformer.
	self assert: window isBuilt.
	self assert: window presenter application equals: application.
	
	window close
]
