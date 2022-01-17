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
	#category : #'RewriteRuleTools-ChangesBrowser'
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

	self layout: (SpPanedLayout newLeftToRight
		add: listPresenter;
		add: codePresenter;
		positionOfSlider: 30 percent;
		yourself)
]

{ #category : #initialization }
RTOccurrencesBrowserPresenter >> initializePresenters [

	codePresenter := self newCode.
	listPresenter := self newList.
	listPresenter
		activateOnSingleClick;
		headerTitle: 'Matches founded';
		display: [ :item | item sourceAnchor entity printString ].
	self initializeLayout
]

{ #category : #initialization }
RTOccurrencesBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 800 @ 500;
		askOkToClose: false
]
