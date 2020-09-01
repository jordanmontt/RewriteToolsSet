Class {
	#name : #RewriteRuleLoaderPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'ruleLoader'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RewriteRuleLoaderPresenterTest >> setUp [

	super setUp.
	ruleLoader := RewriteRuleLoaderPresenter new
]

{ #category : #tests }
RewriteRuleLoaderPresenterTest >> testDeleteRule [

	| newlyCreatedRule |
	newlyCreatedRule := CustomRuleGenerator new
		                    searchFor: '';
		                    replaceWith: '';
		                    generateRule: 'TempRuleForTestTheLoader'
		                    forPackage: 'Custom'.
	ruleLoader refreshRulesListItems.
	ruleLoader rulesList selectItem: newlyCreatedRule.
	ruleLoader deleteRule.
	self
		assert: (ruleLoader rulesList items includes: newlyCreatedRule)
		equals: false
]

{ #category : #tests }
RewriteRuleLoaderPresenterTest >> testLoadRule [

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

{ #category : #tests }
RewriteRuleLoaderPresenterTest >> testOpenRuleInBasicEditor [

	| basicEditorWindow |
	basicEditorWindow := ruleLoader class openRuleInBasicEditor:
		                     DefaultRule new.
	self assert: basicEditorWindow isBuilt equals: true.
	basicEditorWindow close
]

{ #category : #tests }
RewriteRuleLoaderPresenterTest >> testrefreshRulesListItems [

	| newlyCreatedRule |
	newlyCreatedRule := CustomRuleGenerator new
		                    searchFor: '';
		                    replaceWith: '';
		                    generateRule:
			                    'ACustomRuleJustForTestingTheLoader'
		                    forPackage: 'Custom'.
	ruleLoader refreshRulesListItems.
	self assert: (ruleLoader rulesList items includes: newlyCreatedRule ) equals: true.
	ruleLoader rulesList selectItem: newlyCreatedRule.
	ruleLoader deleteRule 
]
