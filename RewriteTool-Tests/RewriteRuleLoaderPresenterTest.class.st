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
RewriteRuleLoaderPresenterTest >> testClose [

	| window |
	window := ruleLoader openWithSpec.
	ruleLoader close.
	self deny: window isBuilt
]

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testDeleteRule [

	| newlyCreatedRule |
	newlyCreatedRule := CustomRuleGenerator new
		                    searchFor: '';
		                    replaceWith: '';
		                    generateRule: 'TempRuleForTestTheLoader'
		                    forPackage: 'Custom'.
	ruleLoader setAllRulesAsTableItems.
	ruleLoader rulesTable selectItem: newlyCreatedRule.
	ruleLoader deleteRule.
	self deny: (ruleLoader rulesTable items includes: newlyCreatedRule).
	self assert: (Smalltalk classNamed: #TempRuleForTestTheLoader) isNil
]

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testFilterRules [

	ruleLoader filterRules: 'xxxy'.
	self assertEmpty: ruleLoader rulesTable items.
	ruleLoader filterRules: 'rt'.
	self denyEmpty: ruleLoader rulesTable items.
	ruleLoader filterRules: 'default'.
	self assert: ruleLoader rulesTable items size equals: 2.
	ruleLoader filterRules: ''.
	self
		assertCollection: ruleLoader rulesTable items
		hasSameElements: ruleLoader getAllRules
]

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testGetAllRules [

	self
		assertCollection: ruleLoader getAllRules
		hasSameElements: RBCustomTransformationRule subclasses
]

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testLoadRuleInBasicEditor [

	| rewriteBasicEditorWindow |
	ruleLoader rulesTable selectItem: DefaultRule.
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
	ruleLoader rulesTable selectItem: DefaultRule.
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
	ruleLoader rulesTable selectItem: DefaultRule.
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
RewriteRuleLoaderPresenterTest >> testSetAllRulesAsTableItems [

	| newlyCreatedRule |
	newlyCreatedRule := CustomRuleGenerator new
		                    searchFor: '';
		                    replaceWith: '';
		                    generateRule:
			                    'ACustomRuleJustForTestingTheLoader'
		                    forPackage: 'Custom'.
	ruleLoader setAllRulesAsTableItems.
	self assert: (ruleLoader rulesTable items includes: newlyCreatedRule).
	self
		assertCollection: ruleLoader rulesTable items
		includesAll: CustomRuleGenerator getAllRules.
	newlyCreatedRule removeFromSystem
]

{ #category : #test }
RewriteRuleLoaderPresenterTest >> testSetCustomRulesAsTableItems [

	| newlyCreatedRule |
	newlyCreatedRule := CustomRuleGenerator new
		                    searchFor: '';
		                    replaceWith: '';
		                    generateRule:
			                    'ACustomRuleJustForTestingTheLoaderII'
		                    forPackage: 'Custom'.
	ruleLoader setAllRulesAsTableItems.
	self assert: (ruleLoader rulesTable items includes: newlyCreatedRule).
	self
		assertCollection: ruleLoader rulesTable items
		includesAll: CustomRuleGenerator getOnlyCustomRules.
	newlyCreatedRule removeFromSystem
]
