Class {
	#name : #RTRuleLoaderPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'ruleLoader'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RTRuleLoaderPresenterTest >> setUp [

	super setUp.
	ruleLoader := RTRuleLoaderPresenter new
]

{ #category : #tests }
RTRuleLoaderPresenterTest >> testDeleteRule [

	| ruleHolder newlySavedRule |
	ruleHolder := RTRuleHolder lhs: '' rhs: ''.
	newlySavedRule := RTRuleSaver storeRuleOnDisk: ruleHolder name: 'someRandomNameForTesting222'.
	ruleLoader setAllRulesAsTableItems.
	ruleLoader rulesTableSelector rulesTable selectItem: newlySavedRule.
	ruleLoader deleteRule.
	self deny: (ruleLoader rulesTableSelector rulesTable items includes: newlySavedRule)
]

{ #category : #tests }
RTRuleLoaderPresenterTest >> testOpen [

	| loaderWindow |
	loaderWindow := ruleLoader class open.
	self assert: loaderWindow isBuilt.
	loaderWindow close
]
