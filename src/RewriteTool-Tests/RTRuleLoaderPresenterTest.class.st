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
RTRuleLoaderPresenterTest >> testCheckboxChanged [

	ruleLoader onlyMyRulesCheckbox click.
	self
		assertCollection: ruleLoader rulesTable items
		hasSameElements: RTCustomRuleGenerator getOnlyCustomRules.
	ruleLoader onlyMyRulesCheckbox click.
	self
		assertCollection: ruleLoader rulesTable items
		hasSameElements: RTCustomRuleGenerator getAllRules
]

{ #category : #tests }
RTRuleLoaderPresenterTest >> testClose [

	| window |
	window := ruleLoader openWithSpec.
	ruleLoader close.
	self deny: window isBuilt
]

{ #category : #tests }
RTRuleLoaderPresenterTest >> testDeleteRule [

	| newlyCreatedRule |
	newlyCreatedRule := RTCustomRuleGenerator new
		                    searchFor: '';
		                    replaceWith: '';
		                    generateRule: 'TempRuleForTestTheLoader'
		                    forPackage: 'Custom' isForMethod: false.
	ruleLoader setAllRulesAsTableItems.
	ruleLoader rulesTable selectItem: newlyCreatedRule.
	ruleLoader deleteRule.
	self deny: (ruleLoader rulesTable items includes: newlyCreatedRule).
	self assert: (Smalltalk classNamed: #TempRuleForTestTheLoader) isNil
]

{ #category : #tests }
RTRuleLoaderPresenterTest >> testFilterRules [

	ruleLoader filterRules: 'xxxy'.
	self assertEmpty: ruleLoader rulesTable items.
	ruleLoader filterRules: 'rt'.
	self denyEmpty: ruleLoader rulesTable items.
	ruleLoader filterRules: 'default'.
	self assert: ruleLoader rulesTable items size equals: 2.
	ruleLoader filterRules: ''.
	self
		assertCollection: ruleLoader rulesTable items
		hasSameElements: RTCustomRuleGenerator getAllRules.
	ruleLoader onlyMyRulesCheckbox click.
	ruleLoader filterRules: 'xxxy'.
	self assertEmpty: ruleLoader rulesTable items.
	ruleLoader filterRules: 'default'.
	self assertEmpty: ruleLoader rulesTable items
]

{ #category : #tests }
RTRuleLoaderPresenterTest >> testGetRules [

	self
		assertCollection: ruleLoader getRules
		hasSameElements: RTCustomRuleGenerator getAllRules.
	ruleLoader onlyMyRulesCheckbox click.
	self
		assertCollection: ruleLoader getRules
		hasSameElements: RTCustomRuleGenerator getOnlyCustomRules
]

{ #category : #tests }
RTRuleLoaderPresenterTest >> testLoadRuleInBasicEditor [

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

{ #category : #tests }
RTRuleLoaderPresenterTest >> testLoadRuleInBuilder [

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

{ #category : #tests }
RTRuleLoaderPresenterTest >> testOpen [

	| loaderWindow |
	loaderWindow := ruleLoader class open.
	self assert: loaderWindow isBuilt.
	loaderWindow close
]

{ #category : #tests }
RTRuleLoaderPresenterTest >> testOpenInMatchTool [

	| matchToolWindow |
	ruleLoader rulesTable selectItem: DefaultRule.
	matchToolWindow := ruleLoader openInMatchTool.
	self assert: matchToolWindow isBuilt.
	matchToolWindow close
]

{ #category : #tests }
RTRuleLoaderPresenterTest >> testOpenRuleInBasicEditor [

	| basicEditorWindow |
	basicEditorWindow := ruleLoader class openRuleInBasicEditor:
		                     DefaultRule new.
	self assert: basicEditorWindow isBuilt.
	basicEditorWindow close
]

{ #category : #tests }
RTRuleLoaderPresenterTest >> testOpenRuleInBuilder [

	| basicEditorWindow |
	basicEditorWindow := ruleLoader class openRuleInBuilder:
		                     DefaultRule new.
	self assert: basicEditorWindow isBuilt.
	basicEditorWindow close
]

{ #category : #tests }
RTRuleLoaderPresenterTest >> testSetAllRulesAsTableItems [

	| newlyCreatedRule |
	newlyCreatedRule := RTCustomRuleGenerator new
		                    searchFor: '';
		                    replaceWith: '';
		                    generateRule:
			                    'ACustomRuleJustForTestingTheLoader'
		                    forPackage: 'Custom' isForMethod: false.
	ruleLoader setAllRulesAsTableItems.
	self assert: (ruleLoader rulesTable items includes: newlyCreatedRule).
	self
		assertCollection: ruleLoader rulesTable items
		hasSameElements: RTCustomRuleGenerator getAllRules.
	newlyCreatedRule removeFromSystem
]
