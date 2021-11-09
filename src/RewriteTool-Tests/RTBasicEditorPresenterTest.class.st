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
		equals: rewriteBasicEditor lhs.
	self
		assert: builderWindow presenter rhs
		equals: rewriteBasicEditor rhs.
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
		equals: rewriteBasicEditor lhs.
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

	rewriteBasicEditor rhs: 'patternCode'.
	self
		assert: rewriteBasicEditor rhs
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
		assert: newBasicRewriteEditorWindow presenter lhs
		equals: selectedRule lhs.
	self
		assert: newBasicRewriteEditorWindow presenter rhs
		equals: selectedRule rhs.
	newBasicRewriteEditorWindow close.
	loaderWindow close
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testSearchForPatternCode [

	rewriteBasicEditor lhs: 'patternCode'.
	self
		assert: rewriteBasicEditor lhs
		equals: 'patternCode'
]
