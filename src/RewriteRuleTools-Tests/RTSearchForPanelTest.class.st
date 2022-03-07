"
A RTSearchForPanelTest is a test class for testing the behavior of RTSearchForPanel
"
Class {
	#name : #RTSearchForPanelTest,
	#superclass : #TestCase,
	#instVars : [
		'searchPanel'
	],
	#category : #'RewriteRuleTools-Tests-Panels'
}

{ #category : #running }
RTSearchForPanelTest >> setUp [

	super setUp.
	searchPanel := RTSearchForPanel new
]

{ #category : #tests }
RTSearchForPanelTest >> testLhs [

	searchPanel lhs: 'Some code'.
	self assert: searchPanel lhs equals: 'Some code'
]
