"
An OccurrencesBrowserPresenterTest is a test class for testing the behavior of OccurrencesBrowserPresenter
"
Class {
	#name : #RTOccurrencesBrowserPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'occurrencesBrowserPresenter'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RTOccurrencesBrowserPresenterTest >> setUp [

	super setUp.
	occurrencesBrowserPresenter := RTOccurrencesBrowserPresenter new
]

{ #category : #tests }
RTOccurrencesBrowserPresenterTest >> testCritiques [

	| presenter |
	presenter := RTOccurrencesBrowserPresenter critiques: #(  ).
	self assert: (presenter isKindOf: SpPresenter)
]

{ #category : #tests }
RTOccurrencesBrowserPresenterTest >> testOpen [

	| window |
	window := occurrencesBrowserPresenter open.
	self assert: window isBuilt.
	window close
]
