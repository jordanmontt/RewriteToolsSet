"
A RulesSelectorPresenterTest is a test class for testing the behavior of RulesSelectorPresenter
"
Class {
	#name : #RTRulesSelectorPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'rulesSelector'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RTRulesSelectorPresenterTest >> setUp [

	super setUp.

	rulesSelector := RTRulesSelectorPresenter new
]

{ #category : #tests }
RTRulesSelectorPresenterTest >> testCustomRulesCheckBoxChanged [

	rulesSelector onlyMyRulesCheckbox state: false.
	self
		assertCollection: rulesSelector items
		includesAll: RTCustomRuleGenerator getAllRules.
	rulesSelector onlyMyRulesCheckbox state: true.
	self
		assertCollection: rulesSelector items
		includesAll: RTCustomRuleGenerator getOnlyCustomRules
]

{ #category : #tests }
RTRulesSelectorPresenterTest >> testOpen [

	| window |
	window := RTRulesSelectorPresenter open.
	self assert: window isBuilt.
	window close
]

{ #category : #tests }
RTRulesSelectorPresenterTest >> testSelectAllCheckboxStatusChanged [

	self assertEmpty: rulesSelector selectedRules.
	rulesSelector selectAllCheckbox state: true.
	self
		assertCollection: rulesSelector selectedRules
		hasSameElements: RTCustomRuleGenerator getAllRules.
	rulesSelector selectAllCheckbox state: false.
	self assertEmpty: rulesSelector selectedRules
]

{ #category : #tests }
RTRulesSelectorPresenterTest >> testSelectedRules [

	| collection |
	collection := { DefaultRule }.
	rulesSelector selectedRules: (OrderedCollection withAll: collection).
	self
		assertCollection: rulesSelector selectedRules
		hasSameElements: collection
]
