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
RewriteBasicEditorPresenterTest >> testCreateRuleClassForPackage [

	| newlyCreatedRule |
	rewriteBasicEditor
		searchForPatternCode: '`@expression ifTrue: [ `@codeBlock ]';
		replaceWithPatternCode:
			'`@expression ifFalse: [ ^ self ]. `@codeBlock'.
	newlyCreatedRule := rewriteBasicEditor
		                    createRuleClass: 'TemporaryCustomRuleForTesting'
		                    forPackage: 'Custom'.
	self deny: newlyCreatedRule equals: nil.
	newlyCreatedRule removeFromSystem
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
	"The class TemporaryDefaultRuleForTesting is not created until the test runs."
	temporaryDefaultRuleForTesting := (rewriteBasicEditor
		                                   createRuleClass:
		                                   'TemporaryDefaultRuleForTesting'
		                                   forPackage: 'Custom') new.
	self deny: temporaryDefaultRuleForTesting equals: nil.
	self denyEmpty: temporaryDefaultRuleForTesting searchFor.
	self denyEmpty: temporaryDefaultRuleForTesting replaceWith.
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
	"The class TemporaryCustomRuleForTesting is not created until the test runs."
	temporaryCustomRule := (rewriteBasicEditor
		                        createRuleClass:
		                        'TemporaryCustomRuleForTesting'
		                        forPackage: 'Custom') new.
	self deny: temporaryCustomRule equals: nil.
	self assert: temporaryCustomRule searchFor equals: searchForForTest.
	self
		assert: temporaryCustomRule replaceWith
		equals: replaceWithForTest.
	temporaryCustomRule class removeFromSystem
]
