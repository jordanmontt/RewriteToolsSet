"
An ExpressionFinderPresenterTest is a test class for testing the behavior of ExpressionFinderPresenter
"
Class {
	#name : #RTExpressionFinderPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'expressionFinder'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RTExpressionFinderPresenterTest >> setUp [

	super setUp.
	expressionFinder := RTExpressionFinderPresenter new
]

{ #category : #tests }
RTExpressionFinderPresenterTest >> testOpen [

	| window |
	window := RTExpressionFinderPresenter open.
	self assert: window isBuilt.
	window close
]
