"
A RewriteRuleBrowserTests is test class for testing RewriteRuleBrowser.

Instance Variables
	tool:		<RewriteRuleBrowser>

tool
	- an instance of RewriteRuleBrowser

"
Class {
	#name : #RewriteRuleBrowserPresenterTests,
	#superclass : #TestCase,
	#instVars : [
		'tool'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #initialization }
RewriteRuleBrowserPresenterTests >> buildRewriteRuleBrowser [
	self tool: RewriteRuleBrowserPresenter new.
	self tool rules items: (RBTransformationRule subclasses collect: [ :each | each name ]).
	self tool buildWithSpec
]

{ #category : #tests }
RewriteRuleBrowserPresenterTests >> testClassesChanged [
	self buildRewriteRuleBrowser.
	self tool packages selectIndex: 1.
	self tool classes selectIndex: 1.
	self assert: self tool methods selection selectedIndex equals: 0
]

{ #category : #tests }
RewriteRuleBrowserPresenterTests >> testPackagesChanged [
	self buildRewriteRuleBrowser.
	self tool packages selectIndex: 1.
	self assert: self tool packages selection selectedIndexes last ~= 0.
	"self assert: self tool classes selection selectedIndexes first equals: 0"
	self
		assert: self tool classes selection selectedIndexes isEmpty
		equals: true
]

{ #category : #tests }
RewriteRuleBrowserPresenterTests >> testRulesChanged [
	self buildRewriteRuleBrowser.
	self tool rules selectIndex: 1.
	self assert: self tool rules selectedIndex ~= 0.
	self assert: self tool rules selectedItem isNotNil.
	self assert: self tool browseButton isEnabled.
	self assert: self tool rules selectedIndex equals: 1.
	self assert: self tool rules selectedItem isNotNil.
	self assert: self tool browseButton isEnabled
]

{ #category : #tests }
RewriteRuleBrowserPresenterTests >> testSimpleRuleUsage2 [
	| rule result |
	self buildRewriteRuleBrowser.
	rule := #MyRule2.
	result := self tool getResultOfRule: rule appliedTo: DemoRule2 asOrderedCollection.
	self assert: result rewriteRule answer
]

{ #category : #accessing }
RewriteRuleBrowserPresenterTests >> tool [
	^ tool
]

{ #category : #accessing }
RewriteRuleBrowserPresenterTests >> tool: anObject [
	tool := anObject
]
