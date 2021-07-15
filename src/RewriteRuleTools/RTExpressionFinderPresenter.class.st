"
I am a presenter that finds all the ocurrenses of a pattern code in all the methods that are in the Pharo image.
"
Class {
	#name : #RTExpressionFinderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'#patternCodePresenter => SpObservableSlot',
		'#searchButton => SpObservableSlot',
		'#cheatSheet'
	],
	#category : #'RewriteRuleTools-ExpressionFinder'
}

{ #category : #accesing }
RTExpressionFinderPresenter class >> icon [

	^ self iconNamed: #smallFind
]

{ #category : #'world menu' }
RTExpressionFinderPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #ExpressionFinder)
		action: [ self open ];
		order: 31;
		parent: #Tools;
		icon: self icon
]

{ #category : #'instance creation' }
RTExpressionFinderPresenter class >> open [

	<script>
	^ self new openWithSpec
]

{ #category : #initialization }
RTExpressionFinderPresenter >> connectPresenters [

	searchButton action: [ self searchExpression ]
]

{ #category : #initialization }
RTExpressionFinderPresenter >> initializeLayout [

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
RTExpressionFinderPresenter >> initializePresenters [

	self initializeLayout.
	patternCodePresenter := self newCode
		                        text: DefaultRule new lhs;
		                        yourself.
	cheatSheet := self newText
		              text: RTBasicEditorPresenter helpText;
		              beNotEditable.
	patternCodePresenter withoutLineNumbers.
	searchButton := self newButton.
	searchButton
		icon: (self iconNamed: #smallFind);
		label: 'Find ocurrences'
]

{ #category : #initialization }
RTExpressionFinderPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Expression Finder';
		initialExtent: 450 @ 300;
		windowIcon: self class icon;
		askOkToClose: false
]

{ #category : #accessing }
RTExpressionFinderPresenter >> patternCode: aString [

	patternCodePresenter text: aString
]

{ #category : #action }
RTExpressionFinderPresenter >> searchExpression [

	| methods rule critiques |
	methods := (RPackage organizer packages flatCollect: #classes) 
		           flatCollect: #methods.
	rule := CustomRewriteRule new
		        lhs: patternCodePresenter text;
		        yourself.
	critiques := RTCustomRuleGenerator
		             obtainCritiques: methods
		             forRules: { rule }.
	^ (RTOccurrencesBrowserPresenter critiques: critiques) open
]
