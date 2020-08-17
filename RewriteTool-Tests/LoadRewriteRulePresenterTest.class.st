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
