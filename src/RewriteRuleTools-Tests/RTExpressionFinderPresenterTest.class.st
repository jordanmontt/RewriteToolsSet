"
An ExpressionFinderPresenterTest is a test class for testing the behavior of ExpressionFinderPresenter
"
Class {
	#name : #RTExpressionFinderPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'expressionFinder'
	],
	#category : #'RewriteRuleTools-Tests'
}

{ #category : #running }
RTExpressionFinderPresenterTest >> setUp [

	super setUp.
	expressionFinder := RTExpressionFinderPresenter new
]

{ #category : #tests }
RTExpressionFinderPresenterTest >> testPatternCode [

	expressionFinder patternCode: 'A pattern'.
	self assert: expressionFinder patternCode equals: 'A pattern'
]
