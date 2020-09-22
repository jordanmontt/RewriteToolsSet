Class {
	#name : #RewriteBasicEditorPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'rewriteBasicEditor'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RewriteBasicEditorPresenterTest >> setUp [

	super setUp.
	rewriteBasicEditor := RewriteBasicEditorPresenter new
]

{ #category : #test }
RewriteBasicEditorPresenterTest >> testHelpText [

	self assert: rewriteBasicEditor helpText isNotNil
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testOpen [

	| basicEditorWindow |
	basicEditorWindow := rewriteBasicEditor class open.
	self assert: basicEditorWindow isBuilt.
	basicEditorWindow close
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testOpenApplier [

	| applier |
	applier := rewriteBasicEditor openApplier.
	self assert: applier isBuilt.
	applier window close
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testOpenHelpBrowser [

	| helpBrowser |
	helpBrowser := rewriteBasicEditor openHelpBrowser.
	self assert: helpBrowser window isDisplayed.
	helpBrowser window close
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testOpenMatchTool [

	| matchTool |
	matchTool := rewriteBasicEditor openMatchTool.
	self assert: matchTool isBuilt.
	matchTool window close
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testOpenRuleLoader [

	| loader |
	loader := rewriteBasicEditor openRuleLoader.
	self assert: loader isBuilt.
	loader window close
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testReplaceWithPatternCode [

	rewriteBasicEditor replaceWithPatternCode: 'patternCode'.
	self
		assert: rewriteBasicEditor replaceWithPatternCode
		equals: 'patternCode'
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testRuleLoadsCorrectly [

	| loaderWindow selectedRule newBasicRewriteEditorWindow loaderPresenter |
	loaderWindow := rewriteBasicEditor openRuleLoader.
	loaderPresenter := loaderWindow presenter.
	loaderPresenter rulesList selectIndex: 1.
	selectedRule := loaderPresenter rulesList selectedItems first new.
	newBasicRewriteEditorWindow := loaderPresenter loadRule.
	self assert: newBasicRewriteEditorWindow isBuilt.
	self
		assert: newBasicRewriteEditorWindow presenter searchForPatternCode
		equals: selectedRule lhs.
	self
		assert: newBasicRewriteEditorWindow presenter replaceWithPatternCode
		equals: selectedRule rhs.
	newBasicRewriteEditorWindow close.
	loaderWindow close
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testSearchForPatternCode [

	rewriteBasicEditor searchForPatternCode: 'patternCode'.
	self
		assert: rewriteBasicEditor searchForPatternCode
		equals: 'patternCode'
]
