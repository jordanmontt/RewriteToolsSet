"
An ExpressionFinderPresenterTest is a test class for testing the behavior of ExpressionFinderPresenter
"
Class {
	#name : #RTExpressionFinderPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'expressionFinder'
	],
	#category : #'RewriteTools-Tests'
}

{ #category : #running }
RTExpressionFinderPresenterTest >> setUp [

	super setUp.
	expressionFinder := RTExpressionFinderPresenter new
]
