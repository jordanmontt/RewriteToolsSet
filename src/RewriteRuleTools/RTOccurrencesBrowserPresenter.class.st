"
I am a presenter for displaying the ocurrences found by `ExpressionFinderPresenter`
"
Class {
	#name : #RTOccurrencesBrowserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'codePresenter',
		'listPresenter'
	],
	#category : #'RewriteRuleTools-ExpressionFinder'
}

{ #category : #accessing }
RTOccurrencesBrowserPresenter class >> critiques: critiques [

	^ self new
		  critiques: critiques;
		  yourself
]

{ #category : #specs }
RTOccurrencesBrowserPresenter class >> title [

	^ 'Occurrences matches'
]

{ #category : #initialization }
RTOccurrencesBrowserPresenter >> connectPresenters [

	listPresenter whenSelectedDo: [ :selectedItem | 
		codePresenter text: selectedItem sourceAnchor entity sourceCode.
		codePresenter selectionInterval: selectedItem sourceAnchor interval ]
]

{ #category : #accessing }
RTOccurrencesBrowserPresenter >> critiques: critiques [

	listPresenter items: critiques
]

{ #category : #initialization }
RTOccurrencesBrowserPresenter >> initializeLayout [

	self layout: (SpPanedLayout newTopToBottom
			 add: #listPresenter;
			 add: #codePresenter;
			 yourself)
]

{ #category : #initialization }
RTOccurrencesBrowserPresenter >> initializePresenters [

	self initializeLayout.
	codePresenter := self newCode.
	listPresenter := self newList.
	listPresenter
		activateOnSingleClick;
		headerTitle: 'Matches founded';
		display: [ :item | item sourceAnchor entity printString ]
]

{ #category : #initialization }
RTOccurrencesBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 400 @ 500;
		askOkToClose: false
]

{ #category : #'instance creation' }
RTOccurrencesBrowserPresenter >> open [

	^ self openWithSpec
]
