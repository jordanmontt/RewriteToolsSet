Class {
	#name : #RTChangesBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'browser'
	],
	#category : #'RewriteRuleTools-Tests-ChangesBrowser'
}

{ #category : #defaults }
RTChangesBrowserTest >> getChangesArray: aClassName [

	| rule changes |
	rule := RTRuleHolder
		lhs: '`@expression ifTrue: [ `@codeBlock ]'
		rhs: '`@expression ifFalse: [ ^ self ].
`@codeBlock'.

	changes := RTAbstractApplier defaultEngineApplier
		calculateChangesForClasses: ((self class environment classNamed: aClassName) methods)
		transformationRules: { rule }.

	^ changes
]

{ #category : #running }
RTChangesBrowserTest >> setUp [

	super setUp.
	browser := RTChangesBrowser new
]

{ #category : #tests }
RTChangesBrowserTest >> testInitialize [
self assertEmpty: browser changes
]

{ #category : #tests }
RTChangesBrowserTest >> testInitializePresenters [

	self assert: browser changesTree isNotNil.
	self assert: browser diffView isNotNil.
	self assert: browser buttonOk isNotNil.
	self assert: browser buttonCancel isNotNil
]
