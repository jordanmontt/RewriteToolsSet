"
A RewriteRuleApplierPresenterTest is a test class for testing the behavior of RewriteRuleApplierPresenter
"
Class {
	#name : #RTRuleApplierPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'applier'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RTRuleApplierPresenterTest >> setUp [

	super setUp.
	applier := RTRuleTransformerPresenter new
]

{ #category : #tests }
RTRuleApplierPresenterTest >> testOpen [

	| applierWindow |
	applierWindow := RTRuleTransformerPresenter open.
	self assert: applierWindow isBuilt.
	applierWindow close
]

{ #category : #tests }
RTRuleApplierPresenterTest >> testRunReplace [

	| changesBrowserWindow |
	changesBrowserWindow := applier runReplace.
	self assert: changesBrowserWindow isBuilt.
	changesBrowserWindow close
]
