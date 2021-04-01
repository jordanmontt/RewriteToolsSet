"
I am a presenter for displaying the ocurrences found by `ExpressionFinderPresenter`
"
Class {
	#name : #OccurrencesBrowserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'#codePresenter => SpObservableSlot',
		'#listPresenter => SpObservableSlot'
	],
	#category : #'RewriteRuleEditor-ExpressionFinder'
}

{ #category : #accessing }
OccurrencesBrowserPresenter class >> critiques: critiques [

	^ self new
		  critiques: critiques;
		  yourself
]

{ #category : #specs }
OccurrencesBrowserPresenter class >> title [

	^ 'Occurrences matches'
]

{ #category : #initialization }
OccurrencesBrowserPresenter >> connectPresenters [

	listPresenter whenSelectedDo: [ :selectedItem | 
		codePresenter text: selectedItem sourceAnchor entity sourceCode.
		codePresenter selectionInterval: selectedItem sourceAnchor interval ]
]

{ #category : #accessing }
OccurrencesBrowserPresenter >> critiques: critiques [

	listPresenter items: critiques
]

{ #category : #initialization }
OccurrencesBrowserPresenter >> initializeLayout [

	self layout: (SpPanedLayout newTopToBottom
			 add: #listPresenter;
			 add: #codePresenter;
			 yourself)
]

{ #category : #initialization }
OccurrencesBrowserPresenter >> initializePresenters [

	self initializeLayout.
	codePresenter := self newCode.
	listPresenter := self newList.
	listPresenter
		activateOnSingleClick;
		headerTitle: 'Matches founded';
		display: [ :item | item sourceAnchor entity printString ]
]

{ #category : #initialization }
OccurrencesBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 400 @ 500;
		askOkToClose: false
]

{ #category : #'instance creation' }
OccurrencesBrowserPresenter >> open [

	^ self openWithSpec
]
