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

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testApplierOpens [

	| applier |
	applier := rewriteBasicEditor openApplier.
	self assert: applier isBuilt.
	applier window close
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testHelpBrowserOpens [

	| helpBrowser |
	helpBrowser := rewriteBasicEditor openHelpBrowser.
	self assert: helpBrowser window isDisplayed.
	helpBrowser window close
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testMatchToolOpens [

	| matchTool |
	matchTool := rewriteBasicEditor openMatchTool.
	self assert: matchTool isBuilt.
	matchTool window close
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testRuleLoaderOpens [

	| loader |
	loader := rewriteBasicEditor openRuleLoader.
	self assert: loader isBuilt.
	loader window close
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testRuleLoadsCorrectly [

	| loaderWindow selectedRule newBasicRewriteEditorWindow loaderPresenter |
	loaderWindow := rewriteBasicEditor openRuleLoader.
	loaderPresenter := loaderWindow presenter.
	loaderPresenter rulesList selectIndex: 2.
	selectedRule := loaderPresenter rulesList selectedItems first new.
	newBasicRewriteEditorWindow := loaderPresenter loadRule.
	self assert: newBasicRewriteEditorWindow isBuilt.
	self
		assert: newBasicRewriteEditorWindow presenter searchForPatternCode
		equals: selectedRule searchFor.
	self
		assert: newBasicRewriteEditorWindow presenter replaceWithPatternCode
		equals: selectedRule replaceWith.
	newBasicRewriteEditorWindow close.
	loaderWindow close
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testSaveDefaultRule [

	| temporaryDefaultRuleForTesting |
	rewriteBasicEditor
		createRuleClass: 'TemporaryDefaultRuleForTesting'
		forPackage: 'Custom'.
	"The class TemporaryDefaultRuleForTesting is not created until the test runs."
	temporaryDefaultRuleForTesting := (self class environment 
		                                   classNamed:
		                                   #TemporaryDefaultRuleForTesting)
		                                  new.
	self deny: temporaryDefaultRuleForTesting equals: nil.
	self assert: temporaryDefaultRuleForTesting searchFor isNotEmpty.
	self assert: temporaryDefaultRuleForTesting replaceWith isNotEmpty.
	self assert: temporaryDefaultRuleForTesting input isNotNil.
	self assert: temporaryDefaultRuleForTesting output isNotNil.
	temporaryDefaultRuleForTesting class removeFromSystem
]

{ #category : #tests }
RewriteBasicEditorPresenterTest >> testSaveRule [

	| searchForForTest replaceWithForTest temporaryCustomRule |
	searchForForTest := '`variable1 isNil ifTrue: `@block1.
`.Statement1'.
	replaceWithForTest := '`variable1 ifNil: `@block1.
`.Statement1'.
	rewriteBasicEditor
		searchForPatternCode: searchForForTest;
		replaceWithPatternCode: replaceWithForTest.
	rewriteBasicEditor
		createRuleClass: 'TemporaryCustomRuleForTesting'
		forPackage: 'Custom'.
	"The class TemporaryCustomRuleForTesting is not created until the test runs."
	temporaryCustomRule := (self class environment classNamed:
		                        'TemporaryCustomRuleForTesting') new.
	self deny: temporaryCustomRule equals: nil.
	self
		assert: temporaryCustomRule searchFor
		equals: searchForForTest.
	self
		assert: temporaryCustomRule replaceWith
		equals: replaceWithForTest.
	temporaryCustomRule class removeFromSystem
]
