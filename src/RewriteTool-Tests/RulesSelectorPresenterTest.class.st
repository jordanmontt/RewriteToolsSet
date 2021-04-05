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
