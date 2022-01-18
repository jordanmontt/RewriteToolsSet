"
A RewriteRuleApplierPresenterTest is a test class for testing the behavior of RewriteRuleApplierPresenter
"
Class {
	#name : #RTRuleApplierPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'applier'
	],
	#category : #'RewriteTools-Tests'
}

{ #category : #running }
RTRuleApplierPresenterTest >> setUp [

	super setUp.
	applier := RTCodeTransformerPresenter new
]

{ #category : #tests }
RTRuleApplierPresenterTest >> testRunReplace [

	| changesBrowserWindow |
	changesBrowserWindow := applier runReplace.
	self assert: changesBrowserWindow isBuilt.
	changesBrowserWindow close
]
