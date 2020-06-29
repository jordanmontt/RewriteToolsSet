Class {
	#name : #BasicEditorTest,
	#superclass : #TestCase,
	#instVars : [
		'rewriteBasicEditor'
	],
	#category : #'RewriteRule-Tests'
}

{ #category : #running }
BasicEditorTest >> setUp [
	rewriteBasicEditor := RewriteBasicEditorPresenter new.

	
]

{ #category : #tests }
BasicEditorTest >> testApplierOpens [
	| applier |
	applier := rewriteBasicEditor openApplier.
	self assert: applier isBuilt.
	applier window close
]

{ #category : #tests }
BasicEditorTest >> testRuleLoaderOpens [
	| loader |
	loader := rewriteBasicEditor openRuleLoader.
	self assert: loader isBuilt.
	loader window close
]

{ #category : #tests }
BasicEditorTest >> testRuleLoadsCorrectly [
	| loaderWindow selectedRule newBasicRewriteEditorWindow loaderPresenter |
	loaderWindow := rewriteBasicEditor openRuleLoader.
	loaderPresenter := loaderWindow presenter.
	loaderPresenter rulesList selectIndex: 2.
	selectedRule := loaderPresenter rulesList selectedItems first new.
	newBasicRewriteEditorWindow := loaderPresenter loadRule.
	self assert: newBasicRewriteEditorWindow isBuilt.
	self
		assert: newBasicRewriteEditorWindow presenter searchForCode
		equals: selectedRule searchFor.
	self
		assert: newBasicRewriteEditorWindow presenter replaceWithCode
		equals: selectedRule replaceWith.
	newBasicRewriteEditorWindow close.
	loaderWindow close
]

{ #category : #running }
BasicEditorTest >> testSaveDefaultRule [
	rewriteBasicEditor
		createRuleClass: 'TemporaryDefaultRuleForTesting'
		forPackage: 'Test'.
	"The class TemporaryDefaultRuleForTesting is not created yet."
	self
		assert: (Smalltalk globals hasClassNamed: 'TemporaryDefaultRuleForTesting').
	(Smalltalk globals classNamed: #TemporaryDefaultRuleForTesting)
		removeFromSystem
]

{ #category : #running }
BasicEditorTest >> testSaveRule [
	rewriteBasicEditor
		searchForCode:
			'`variable1 isNil
	ifTrue: `@block1.
`.Statement1';
		replaceWithCode:
			'`variable1 ifNil: `@block1.
`.Statement1'.
	rewriteBasicEditor
		createRuleClass: 'TemporaryCustomRuleForTesting'
		forPackage: 'Test'.
	"The class TemporaryCustomRuleForTesting is not created yet."
	self
		assert: (Smalltalk globals hasClassNamed: 'TemporaryCustomRuleForTesting').
	(Smalltalk globals
		classNamed: #TemporaryCustomRuleForTesting )removeFromSystem
]
