"
I am a presenter that finds all the ocurrenses of a pattern code in all the methods that are in the Pharo image.
"
Class {
	#name : #ExpressionFinderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'#patternCodePresenter => SpObservableSlot',
		'#searchButton => SpObservableSlot',
		'#cheatSheet'
	],
	#category : #'RewriteRuleTools-ExpressionFinder'
}

{ #category : #accesing }
ExpressionFinderPresenter class >> icon [

	^ self iconNamed: #smallFind
]

{ #category : #'world menu' }
ExpressionFinderPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #ExpressionFinder)
		action: [ self open ];
		order: 31;
		parent: #Tools;
		icon: self icon
]

{ #category : #'instance creation' }
ExpressionFinderPresenter class >> open [

	<script>
	^ self new openWithSpec
]

{ #category : #initialization }
ExpressionFinderPresenter >> connectPresenters [

	searchButton action: [ self searchExpression ]
]

{ #category : #initialization }
ExpressionFinderPresenter >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 add: (SpBoxLayout newTopToBottom
					  add: (SpLabelPresenter new
							   label: 'Pattern code';
							   yourself)
					  expand: false;
					  add: #patternCodePresenter;
					  yourself);
			 add: (SpBoxLayout newTopToBottom
					  add: #cheatSheet expand: true;
					  add: #searchButton expand: false;
					  yourself)
			 width: 120;
			 yourself)
]

{ #category : #initialization }
ExpressionFinderPresenter >> initializePresenters [

	self initializeLayout.
	patternCodePresenter := self newCode
		                        text: DefaultRule new lhs;
		                        yourself.
	cheatSheet := self newText
		              text: RewriteBasicEditorPresenter helpText;
		              beNotEditable.
	patternCodePresenter withoutLineNumbers.
	searchButton := self newButton.
	searchButton
		icon: (self iconNamed: #smallFind);
		label: 'Find ocurrences'
]

{ #category : #initialization }
ExpressionFinderPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Expression Finder';
		initialExtent: 450 @ 300;
		windowIcon: self class icon;
		askOkToClose: false
]

{ #category : #accessing }
ExpressionFinderPresenter >> patternCode: aString [

	patternCodePresenter text: aString
]

{ #category : #action }
ExpressionFinderPresenter >> searchExpression [

	| classes rule critiques |
	classes := RPackage organizer packages flatCollect: #classes.
	rule := ReNodeMatchRule new
		        addMatchingExpression: patternCodePresenter text;
		        yourself.
	critiques := RewriteCustomRuleGenerator
		             obtainCritiques: classes
		             forRules: { rule }.
	^ (OccurrencesBrowserPresenter critiques: critiques) open
]
