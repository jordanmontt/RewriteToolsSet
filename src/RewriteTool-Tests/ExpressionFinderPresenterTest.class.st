"
An ExpressionFinderPresenterTest is a test class for testing the behavior of ExpressionFinderPresenter
"
Class {
	#name : #ExpressionFinderPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'expressionFinder'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
ExpressionFinderPresenterTest >> setUp [

	super setUp.
	expressionFinder := ExpressionFinderPresenter new
]

{ #category : #tests }
ExpressionFinderPresenterTest >> testOpen [

	| window |
	window := ExpressionFinderPresenter open.
	self assert: window isBuilt.
	window close
]
