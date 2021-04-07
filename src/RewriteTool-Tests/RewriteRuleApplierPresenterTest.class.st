"
A RewriteRuleApplierPresenterTest is a test class for testing the behavior of RewriteRuleApplierPresenter
"
Class {
	#name : #RewriteRuleApplierPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'applier'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RewriteRuleApplierPresenterTest >> setUp [

	super setUp.
	applier := RewriteRuleApplierPresenter new
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testClassesChanged [

	| rewriteToolPackages |
	rewriteToolPackages := RBBrowserEnvironment new packages select: [ :e | 
		                       e name includesSubstring: 'Rewrite' ].
	applier packagesListWithFilter listPresenter selectItems:
		rewriteToolPackages.
	applier classesListWithFilter listPresenter selectItem:
		MatchToolPresenter.
	self
		assertCollection: applier selectedClasses
		hasSameElements: { MatchToolPresenter }.
	self
		assertCollection: applier methodsListWithFilter items
		hasSameElements: ({ MatchToolPresenter } flatCollect: #selectors)
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testOpen [

	| applierWindow |
	applierWindow := RewriteRuleApplierPresenter open.
	self assert: applierWindow isBuilt.
	applierWindow close
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testOpenLoader [

	| window |
	window := applier openLoader.
	self assert: window isBuilt.
	window close
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testPackagesChanged [

	| rewriteToolPackages someClassesInRewriteTool |
	rewriteToolPackages := RBBrowserEnvironment new packages select: [ :e | 
		                       e name includesSubstring: 'Rewrite' ].
	someClassesInRewriteTool := { 
		                            RewriteBasicEditorPresenter.
		                            RewriteRuleApplierPresenter.
		                            MatchToolPresenter }.
	applier packagesListWithFilter listPresenter selectItems:
		rewriteToolPackages.
	self
		assertCollection: applier selectedClasses
		includesAll: someClassesInRewriteTool.
	self
		assertCollection: applier classesListWithFilter items
		includesAll: someClassesInRewriteTool.
	self
		assertCollection: applier methodsListWithFilter items
		includesAll: (someClassesInRewriteTool flatCollect: #selectors)
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testPopulateMethodsListWithEnvironmentClasses [

	applier selectedClasses: { MatchToolPresenter }.
	applier populateMethodsListWithEnvironmentClasses.
	self
		assertCollection: applier methodsListWithFilter items
		hasSameElements: ({ MatchToolPresenter } flatCollect: #selectors).
	"No class must be in the items because we modified the environment directly."
	self assertEmpty: applier classesListWithFilter items
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testRunReplace [

	| changesBrowserWindow |
	applier selectedClasses: { MatchToolPresenter }.
	changesBrowserWindow := applier runReplace.
	self assert: changesBrowserWindow isBuilt.
	changesBrowserWindow close
]