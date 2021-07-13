Class {
	#name : #RTBasicEditorPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'rewriteBasicEditor'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RTBasicEditorPresenterTest >> setUp [

	super setUp.
	rewriteBasicEditor := RTBasicEditorPresenter new
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testHelpText [

	self assert: rewriteBasicEditor class helpText isNotNil
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testOpen [

	| basicEditorWindow |
	basicEditorWindow := rewriteBasicEditor class open.
	self assert: basicEditorWindow isBuilt.
	basicEditorWindow close
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testOpenApplier [

	| applier |
	applier := rewriteBasicEditor openApplier.
	self assert: applier isBuilt.
	applier window close
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testOpenBuilder [

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

{ #category : #tests }
RTBasicEditorPresenterTest >> testOpenExpressionFinder [

	| expressionFinder |
	expressionFinder := rewriteBasicEditor openExpressionFinder.
	self assert: expressionFinder isBuilt.
	expressionFinder window close
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testOpenHelpBrowser [

	| helpBrowser |
	helpBrowser := rewriteBasicEditor openHelpBrowser.
	self assert: helpBrowser window isDisplayed.
	helpBrowser window close
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testOpenMatchTool [

	| matchTool |
	matchTool := rewriteBasicEditor openMatchTool.
	self assert: matchTool isBuilt.
	self
		assert: matchTool presenter patternCode
		equals: rewriteBasicEditor searchForPatternCode.
	matchTool window close
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testOpenRuleLoader [

	| loader |
	loader := rewriteBasicEditor openRuleLoader.
	self assert: loader isBuilt.
	loader window close
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testReplaceWithPatternCode [

	rewriteBasicEditor replaceWithPatternCode: 'patternCode'.
	self
		assert: rewriteBasicEditor replaceWithPatternCode
		equals: 'patternCode'
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testRuleLoadsCorrectly [

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

{ #category : #tests }
RTBasicEditorPresenterTest >> testSearchForPatternCode [

	rewriteBasicEditor searchForPatternCode: 'patternCode'.
	self
		assert: rewriteBasicEditor searchForPatternCode
		equals: 'patternCode'
]
