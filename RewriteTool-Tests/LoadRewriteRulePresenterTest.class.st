Class {
	#name : #LoadRewriteRulePresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'ruleLoader'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
LoadRewriteRulePresenterTest >> setUp [

	super setUp.
	ruleLoader := LoadRewriteRulePresenter new
]

{ #category : #tests }
LoadRewriteRulePresenterTest >> testDeleteRule [

	CustomRuleGenerator new
		searchFor: '';
		replaceWith: '';
		generateRule: 'TemporaryCustomRuleForTesting' forPackage: 'Custom'.
	ruleLoader rulesList selectItem:
		(self class environment classNamed: 'TemporaryCustomRuleForTesting').
	ruleLoader deleteRule.
	self
		assert:
		(self class environment classNamed: 'TemporaryCustomRuleForTesting')
		equals: nil
]

{ #category : #tests }
LoadRewriteRulePresenterTest >> testLoadRule [

	| rewriteBasicEditorWindow |
	ruleLoader rulesList selectItem: DefaultRule.
	rewriteBasicEditorWindow := ruleLoader loadRule.
	self
		assert: rewriteBasicEditorWindow presenter replaceWithPatternCode
		equals: DefaultRule new replaceWith.
			self
		assert: rewriteBasicEditorWindow presenter searchForPatternCode
		equals: DefaultRule new searchFor.
	rewriteBasicEditorWindow close
]
