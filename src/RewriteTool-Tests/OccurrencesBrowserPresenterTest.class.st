"
An OccurrencesBrowserPresenterTest is a test class for testing the behavior of OccurrencesBrowserPresenter
"
Class {
	#name : #OccurrencesBrowserPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'occurrencesBrowserPresenter'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
OccurrencesBrowserPresenterTest >> setUp [

	super setUp.
	occurrencesBrowserPresenter := OccurrencesBrowserPresenter new
]

{ #category : #tests }
OccurrencesBrowserPresenterTest >> testCritiques [

	| presenter |
	presenter := OccurrencesBrowserPresenter critiques: #(  ).
	self assert: (presenter isKindOf: SpPresenter)
]

{ #category : #test }
OccurrencesBrowserPresenterTest >> testOpen [

	| window |
	window := occurrencesBrowserPresenter open.
	self assert: window isBuilt.
	window close
]
