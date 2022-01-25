"
A RTReplaceWithPanelTest is a test class for testing the behavior of RTReplaceWithPanel
"
Class {
	#name : #RTReplaceWithPanelTest,
	#superclass : #TestCase,
	#instVars : [
		'replacePanel'
	],
	#category : #'RewriteRuleTools-Tests'
}

{ #category : #running }
RTReplaceWithPanelTest >> setUp [

	super setUp.
	replacePanel := RTReplaceWithPanel new
]

{ #category : #tests }
RTReplaceWithPanelTest >> testRhs [

	replacePanel rhs: 'Some code'.
	self assert: replacePanel rhs equals: 'Some code'
]
