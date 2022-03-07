"
An ExpressionFinderPresenterTest is a test class for testing the behavior of ExpressionFinderPresenter
"
Class {
	#name : #RTExpressionFinderPresenterTest,
	#superclass : #RTAbstractToolTest,
	#instVars : [
		'expressionFinder'
	],
	#category : #'RewriteRuleTools-Tests-ExpressionFinder'
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

{ #category : #accessing }
RTExpressionFinderPresenterTest >> toolClass [

	^ RTExpressionFinderPresenter
]
