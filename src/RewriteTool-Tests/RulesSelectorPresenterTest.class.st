"
A RulesSelectorPresenterTest is a test class for testing the behavior of RulesSelectorPresenter
"
Class {
	#name : #RulesSelectorPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'rulesSelector'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RulesSelectorPresenterTest >> setUp [

	super setUp.

	rulesSelector := RulesSelectorPresenter new
]

{ #category : #test }
RulesSelectorPresenterTest >> testCustomRulesCheckBoxChanged [

	rulesSelector onlyMyRulesCheckbox state: false.
	self
		assertCollection: rulesSelector items
		includesAll: RewriteCustomRuleGenerator getAllRules.
	rulesSelector onlyMyRulesCheckbox state: true.
	self
		assertCollection: rulesSelector items
		includesAll: RewriteCustomRuleGenerator getOnlyCustomRules
]

{ #category : #test }
RulesSelectorPresenterTest >> testOpen [

	| window |
	window := RulesSelectorPresenter open.
	self assert: window isBuilt.
	window close
]

{ #category : #test }
RulesSelectorPresenterTest >> testSelectAllCheckboxStatusChanged [

	self assertEmpty: rulesSelector selectedRules.
	rulesSelector selectAllCheckbox state: true.
	self
		assertCollection: rulesSelector selectedRules
		hasSameElements: RewriteCustomRuleGenerator getAllRules.
	rulesSelector selectAllCheckbox state: false.
	self assertEmpty: rulesSelector selectedRules
]

{ #category : #test }
RulesSelectorPresenterTest >> testSelectedRules [

	| collection |
	collection := { DefaultRule }.
	rulesSelector selectedRules: (OrderedCollection withAll: collection).
	self
		assertCollection: rulesSelector selectedRules
		hasSameElements: collection
]
