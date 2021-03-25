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

{ #category : #defaults }
RewriteRuleApplierPresenterTest >> createDirtyClassForTesting: aClassName [

	| classWithDirtyMethod |
	classWithDirtyMethod := Object
		                        subclass: aClassName
		                        instanceVariableNames: ''
		                        classVariableNames: ''
		                        package:
		                        CustomRuleGenerator packageName
		                        , '-JustForTesting'.
	classWithDirtyMethod
		compile: 'aMethod
		a = b ifTrue: [ ^ self]'
		classified: 'initialization'.
	^ classWithDirtyMethod
]

{ #category : #defaults }
RewriteRuleApplierPresenterTest >> createRuleForTesting [

	^ CustomRuleGenerator new
		  searchFor: '`@expression ifTrue: [ `@codeBlock ]';
		  replaceWith: '`@expression ifFalse: [ ^ self ]. `@codeBlock';
		  generateRule: 'ATemporaryRuleForTestingApplier'
		  forPackage: 'JustForTesting'
]

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
		assertCollection: applier environment
		hasSameElements: { MatchToolPresenter }.
	self
		assertCollection: applier methodsListWithFilter items
		hasSameElements: ({ MatchToolPresenter } flatCollect: #selectors)
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testCustomRulesCheckBoxChanged [

	applier onlyMyRulesCheckbox state: false.
	self
		assertCollection: applier rulesDropdown items
		includesAll: CustomRuleGenerator getAllRules.
	applier onlyMyRulesCheckbox state: true.
	self
		assertCollection: applier rulesDropdown items
		includesAll: CustomRuleGenerator getOnlyCustomRules
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testGetAllRules [

	self
		assertCollection: applier getAllRules
		hasSameElements: CustomRuleGenerator getAllRules
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testObtainChangesForRule [

	| changes rule dirtyClass |
	rule := self createRuleForTesting.
	dirtyClass := self createDirtyClassForTesting:
		              'ADirtyClassForThisTest'.
	changes := RewriteRuleApplierPresenter
		           obtainChanges:
		           (RBClassEnvironment classes: { dirtyClass })
		           forRule: rule new.
	self denyEmpty: changes.
	rule removeFromSystem.
	dirtyClass removeFromSystem
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
		assertCollection: applier environment
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

	applier environment: { MatchToolPresenter }.
	applier populateMethodsListWithEnvironmentClasses.
	self
		assertCollection: applier methodsListWithFilter items
		hasSameElements: ({ MatchToolPresenter } flatCollect: #selectors).
	"No class must be in the items because we modified the environment directly."
	self assertEmpty: applier classesListWithFilter items
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testRefreshRulesItems [

	applier refreshRulesItems.
	self
		assertCollection: applier rulesDropdown items
		hasSameElements: CustomRuleGenerator getAllRules
]

{ #category : #test }
RewriteRuleApplierPresenterTest >> testRunReplace [

	| changesBrowserWindow |
	applier environment: { MatchToolPresenter }.
	changesBrowserWindow := applier runReplace.
	self assert: changesBrowserWindow isBuilt.
	changesBrowserWindow close
]
