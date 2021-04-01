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

{ #category : #test }
RewriteBasicEditorPresenterTest >> testOpen [

	| basicEditorWindow |
	basicEditorWindow := rewriteBasicEditor class open.
	self assert: basicEditorWindow isBuilt.
	basicEditorWindow close
]

{ #category : #test }
RewriteBasicEditorPresenterTest >> testOpenApplier [

	| applier |
	applier := rewriteBasicEditor openApplier.
	self assert: applier isBuilt.
	applier window close
]

{ #category : #test }
RewriteBasicEditorPresenterTest >> testOpenBuilder [

	| builderWindow |
	builderWindow := rewriteBasicEditor openBuilder.
	self assert: builderWindow isBuilt.
	self
		assert: builderWindow presenter lhs
		equals: rewriteBasicEditor searchForPatternCode.
	self
		assert: builderWindow presenter rhs
		equals: rewriteBasicEditor replaceWithPatternCode.
	builderWindow close
]

{ #category : #test }
RewriteBasicEditorPresenterTest >> testOpenExpressionFinder [

	| expressionFinder |
	expressionFinder := rewriteBasicEditor openExpressionFinder.
	self assert: expressionFinder isBuilt.
	expressionFinder window close
]

{ #category : #test }
RewriteBasicEditorPresenterTest >> testOpenHelpBrowser [

	| helpBrowser |
	helpBrowser := rewriteBasicEditor openHelpBrowser.
	self assert: helpBrowser window isDisplayed.
	helpBrowser window close
]

{ #category : #test }
RewriteBasicEditorPresenterTest >> testOpenMatchTool [

	| matchTool |
	matchTool := rewriteBasicEditor openMatchTool.
	self assert: matchTool isBuilt.
	self
		assert: matchTool presenter patternCode
		equals: rewriteBasicEditor searchForPatternCode.
	matchTool window close
]

{ #category : #test }
RewriteBasicEditorPresenterTest >> testOpenRuleLoader [

	| loader |
	loader := rewriteBasicEditor openRuleLoader.
	self assert: loader isBuilt.
	loader window close
]

{ #category : #test }
RewriteBasicEditorPresenterTest >> testReplaceWithPatternCode [

	rewriteBasicEditor replaceWithPatternCode: 'patternCode'.
	self
		assert: rewriteBasicEditor replaceWithPatternCode
		equals: 'patternCode'
]

{ #category : #test }
RewriteBasicEditorPresenterTest >> testRuleLoadsCorrectly [

	| loaderWindow selectedRule newBasicRewriteEditorWindow loaderPresenter |
	loaderWindow := rewriteBasicEditor openRuleLoader.
	loaderPresenter := loaderWindow presenter.
	loaderPresenter rulesTable selectIndex: 1.
	selectedRule := loaderPresenter rulesTable selectedItems first new.
	newBasicRewriteEditorWindow := loaderPresenter loadRuleInBasicEditor.
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

{ #category : #test }
RewriteBasicEditorPresenterTest >> testSearchForPatternCode [

	rewriteBasicEditor searchForPatternCode: 'patternCode'.
	self
		assert: rewriteBasicEditor searchForPatternCode
		equals: 'patternCode'
]
