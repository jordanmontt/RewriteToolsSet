"
A RewriteRuleApplierPresenterTest is a test class for testing the behavior of RewriteRuleApplierPresenter
"
Class {
	#name : #RTCodeTransformerPresenterTest,
	#superclass : #RTAbstractToolTest,
	#instVars : [
		'applier'
	],
	#category : #'RewriteRuleTools-Tests-RuleApplier'
}

{ #category : #running }
RTCodeTransformerPresenterTest >> setUp [

	super setUp.
	applier := RTCodeTransformerPresenter new
]

{ #category : #tests }
RTCodeTransformerPresenterTest >> testRunReplace [

	| changesBrowserWindow |
	changesBrowserWindow := applier runReplace.
	self assert: changesBrowserWindow isBuilt.
	changesBrowserWindow close
]

{ #category : #accessing }
RTCodeTransformerPresenterTest >> toolClass [

	^ RTCodeTransformerPresenter
]
