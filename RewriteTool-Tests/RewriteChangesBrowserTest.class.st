Class {
	#name : #RewriteChangesBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'browser'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #defaults }
RewriteChangesBrowserTest >> createDirtyClassForTesting: aClassName [

	| classWithDirtyMethod |
	classWithDirtyMethod := RBTransformationRule
		                        subclass: aClassName
		                        instanceVariableNames: ''
		                        classVariableNames: ''
		                        package: 'JustForTesting'.
	classWithDirtyMethod
		compile: 'aMethod
		a = b ifTrue: [ ^ self]'
		classified: 'initialization'.
	^ classWithDirtyMethod
]

{ #category : #defaults }
RewriteChangesBrowserTest >> getChangesClass: aClassName [

	| env rule |
	rule := CustomRuleGenerator new
		        searchFor: '`@expression ifTrue: [ `@codeBlock ]';
		        replaceWith: '`@expression ifFalse: [ ^ self ].
`@codeBlock';
		        generateRule: 'ATestRuleThatWillBeDeletedSoon'
		        forPackage: 'JustForTesting'.
	env := RBClassEnvironment classes:
		       { (self class environment classNamed: aClassName) }.
	(self class environment classNamed: 'ATestRuleThatWillBeDeletedSoon')
		removeFromSystem.
	^ Array with:
		  (RBSmalllintChecker runRule: rule new onEnvironment: env) builder
]

{ #category : #running }
RewriteChangesBrowserTest >> setUp [

	super setUp.
	browser := RewriteChangesBrowser new
]

{ #category : #test }
RewriteChangesBrowserTest >> testBuildDiffFor [

	| changes classWithDirtyMethod |
	classWithDirtyMethod := self createDirtyClassForTesting:
		                        'DirtyClassThatHasOneMethodForTestingDiff'.
	changes := self getChangesClass:
		           'DirtyClassThatHasOneMethodForTestingDiff'.
	self assert: (browser buildDiffFor: nil) equals: ''.
	self
		assert: (browser buildDiffFor: changes first changes first) leftText 
		equals: changes first changes first oldVersionTextToDisplay.
	self
		assert: (browser buildDiffFor: changes first changes first) rightText
		equals: changes first changes first textToDisplay.
	classWithDirtyMethod removeFromSystem
]

{ #category : #test }
RewriteChangesBrowserTest >> testChanges [

	| changes classWithDirtyMethod |
	classWithDirtyMethod := self createDirtyClassForTesting:
		                        'ADirtyClassThatHasOneMethodForTestingChanges'.
	changes := self getChangesClass:
		           'ADirtyClassThatHasOneMethodForTestingChanges'.
	browser changes: changes.
	self assert: browser changes equals: changes.
	classWithDirtyMethod removeFromSystem
]

{ #category : #test }
RewriteChangesBrowserTest >> testInitialize [
self assertEmpty: browser changes
]

{ #category : #test }
RewriteChangesBrowserTest >> testInitializePresenters [

	self assert: browser changesTree isNotNil.
	self assert: browser diffView isNotNil.
	self assert: browser buttonOk isNotNil.
	self assert: browser buttonCancel isNotNil.
	self assertCollection: browser focusOrder equals: { 
			browser changesTree.
			browser diffView.
			browser buttonOk.
			browser buttonCancel } asOrderedCollection
]

{ #category : #test }
RewriteChangesBrowserTest >> testOpen [

	| changesBrowserWindow |
	changesBrowserWindow := browser open.
	self assert: changesBrowserWindow isBuilt.
	changesBrowserWindow close
]

{ #category : #test }
RewriteChangesBrowserTest >> testSelectedChanges [

	| changes classWithDirtyMethod |
	"At first there is no selected changes."
	self assert: browser selectedChanges isNil.
	classWithDirtyMethod := self createDirtyClassForTesting:
		                        'ADirtyClassThatHasOneMethodForTesting'.
	changes := self getChangesClass:
		           'ADirtyClassThatHasOneMethodForTesting'.
	browser changes: changes.
	"The browser has one change and that change must be in the selectedChanges."
	self assert: browser selectedChanges size equals: 1.
	classWithDirtyMethod removeFromSystem
]
