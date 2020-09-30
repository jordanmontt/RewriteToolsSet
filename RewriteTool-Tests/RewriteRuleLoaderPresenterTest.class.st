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

{ #category : #test }
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

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testLoadRuleInBasicEditor [

	| rewriteBasicEditorWindow |
	ruleLoader rulesList selectItem: DefaultRule.
	rewriteBasicEditorWindow := ruleLoader loadRuleInBasicEditor.
	self
		assert: rewriteBasicEditorWindow presenter replaceWithPatternCode
		equals: DefaultRule new rhs.
	self
		assert: rewriteBasicEditorWindow presenter searchForPatternCode
		equals: DefaultRule new lhs.
	rewriteBasicEditorWindow close
]

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testLoadRuleInBuilder [

	| builderWindow |
	ruleLoader rulesList selectItem: DefaultRule.
	builderWindow := ruleLoader loadRuleInBuilder.
	self assert: builderWindow presenter rhs equals: DefaultRule new rhs.
	self assert: builderWindow presenter lhs equals: DefaultRule new lhs.
	self
		assert: builderWindow presenter inputCode
		equals: DefaultRule new inputCode.
	self
		assert: builderWindow presenter outputCode
		equals: DefaultRule new outputCode.
	builderWindow close
]

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testOpen [

	| loaderWindow |
	loaderWindow := ruleLoader class open.
	self assert: loaderWindow isBuilt.
	loaderWindow close
]

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testOpenInMatchTool [

	| matchToolWindow |
	ruleLoader rulesList selectItem: DefaultRule.
	matchToolWindow := ruleLoader openInMatchTool.
	self assert: matchToolWindow isBuilt.
	matchToolWindow close
]

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testOpenRuleInBasicEditor [

	| basicEditorWindow |
	basicEditorWindow := ruleLoader class openRuleInBasicEditor:
		                     DefaultRule new.
	self assert: basicEditorWindow isBuilt.
	basicEditorWindow close
]

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testOpenRuleInBuilder [

	| basicEditorWindow |
	basicEditorWindow := ruleLoader class openRuleInBuilder:
		                     DefaultRule new.
	self assert: basicEditorWindow isBuilt.
	basicEditorWindow close
]

{ #category : #test }
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
