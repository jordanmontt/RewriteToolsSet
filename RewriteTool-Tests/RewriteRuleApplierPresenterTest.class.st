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
	applier packagesList selectItems: rewriteToolPackages.
	applier classesList selectItem: MatchToolPresenter.
	self
		assertCollection: applier environment
		hasSameElements: { MatchToolPresenter }.
	self
		assertCollection: applier methodsList items
		hasSameElements:
		({ MatchToolPresenter } collect: #selectors) flattened
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testObtainChanges [

	self assert: (applier obtainChanges:
			 (RBClassEnvironment classes: { MatchToolPresenter })) isArray
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testObtainChangesForRule [

	self assert: (RewriteRuleApplierPresenter
			 obtainChanges:
			 (RBClassEnvironment classes: { MatchToolPresenter })
			 forRule: DefaultRule new) isArray
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testOpen [

	| applierWindow |
	applierWindow := RewriteRuleApplierPresenter open.
	self assert: applierWindow isBuilt.
	applierWindow close
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
	applier packagesList selectItems: rewriteToolPackages.
	self
		assertCollection: applier environment
		includesAll: someClassesInRewriteTool.
	self
		assertCollection: applier classesList items
		includesAll: someClassesInRewriteTool.
	self
		assertCollection: applier methodsList items
		includesAll:
		(someClassesInRewriteTool collect: #selectors) flattened
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testPopulateMethodsListWithEnvironmentClasses [

	applier environment: { MatchToolPresenter }.
	applier populateMethodsListWithEnvironmentClasses.
	self
		assertCollection: applier methodsList items
		hasSameElements:
		({ MatchToolPresenter } collect: #selectors) flattened.
	"No class must be in the items because we modified the environment directly."
	self assertEmpty: applier classesList items
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testRunReplace [

	| changesBrowserWindow |
	applier environment: { MatchToolPresenter }.
	changesBrowserWindow := applier runReplace.
	self assert: changesBrowserWindow isBuilt.
	changesBrowserWindow close
]
