"
A RTRulesTableSelectorPresenterTest is a test class for testing the behavior of RTRulesTableSelectorPresenter
"
Class {
	#name : #RTRulesTableSelectorPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'rulesTable'
	],
	#category : #'RewriteRuleTools-Tests'
}

{ #category : #running }
RTRulesTableSelectorPresenterTest >> setUp [

	super setUp.
	rulesTable := RTRulesTableSelectorPresenter new
]

{ #category : #running }
RTRulesTableSelectorPresenterTest >> testOpen [

	| window |
	window := rulesTable open.
	self assert: window isBuilt.
	
	window close
]
