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
	self deny: (ruleLoader rulesList items includes: newlyCreatedRule).
	self assert: (Smalltalk classNamed: #TempRuleForTestTheLoader) isNil
]

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testGetItems [

	self
		assertCollection: ruleLoader getItems
		hasSameElements: RBCustomTransformationRule subclasses
]

{ #category : #tests }
RewriteRuleLoaderPresenterTest >> testLoadRule [

	| rewriteBasicEditorWindow |
	ruleLoader rulesList selectItem: DefaultRule.
	rewriteBasicEditorWindow := ruleLoader loadRule.
	self
		assert: rewriteBasicEditorWindow presenter replaceWithPatternCode
		equals: DefaultRule new rhs.
	self
		assert: rewriteBasicEditorWindow presenter searchForPatternCode
		equals: DefaultRule new lhs.
	rewriteBasicEditorWindow close
]

{ #category : #tests }
RewriteRuleLoaderPresenterTest >> testOpen [

	| loaderWindow |
	loaderWindow := ruleLoader class open.
	self assert: loaderWindow isBuilt.
	loaderWindow close
]

{ #category : #tests }
RewriteRuleLoaderPresenterTest >> testOpenRuleInBasicEditor [

	| basicEditorWindow |
	basicEditorWindow := ruleLoader class openRuleInBasicEditor:
		                     DefaultRule new.
	self assert: basicEditorWindow isBuilt.
	basicEditorWindow close
]

{ #category : #tests }
RewriteRuleLoaderPresenterTest >> testRefreshRulesListItems [

	| newlyCreatedRule |
	newlyCreatedRule := CustomRuleGenerator new
		                    searchFor: '';
		                    replaceWith: '';
		                    generateRule:
			                    'ACustomRuleJustForTestingTheLoader'
		                    forPackage: 'Custom'.
	ruleLoader refreshRulesListItems.
	self assert: (ruleLoader rulesList items includes: newlyCreatedRule).
	 newlyCreatedRule removeFromSystem.
]
