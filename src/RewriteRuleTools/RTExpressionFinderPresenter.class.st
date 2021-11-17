"
I am a presenter that finds all the ocurrenses of a pattern code in all the methods that are in the Pharo image.
"
Class {
	#name : #RTExpressionFinderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'patternCodePresenter',
		'searchButton',
		'cheatSheet'
	],
	#category : #'RewriteRuleTools-ExpressionFinder'
}

{ #category : #accessing }
RTExpressionFinderPresenter class >> icon [

	^ self iconNamed: self iconName
]

{ #category : #accessing }
RTExpressionFinderPresenter class >> iconName [

	^ #smallFind
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
	^ RTApplication new startExpressionFinder
]

{ #category : #initialization }
RTExpressionFinderPresenter >> connectPresenters [

	searchButton action: [ self searchExpression ]
]

{ #category : #initialization }
RTExpressionFinderPresenter >> initializeLayout [

	| tempLayout |
	tempLayout := SpPanedLayout newLeftToRight
		add: patternCodePresenter;
		add: (SpBoxLayout newTopToBottom
			add: cheatSheet expand: true;
			add: searchButton expand: false;
			yourself);
		positionOfSlider: 70 percent;
		yourself.

	self layout: tempLayout
]

{ #category : #initialization }
RTExpressionFinderPresenter >> initializePresenters [
	
	patternCodePresenter := self instantiate: RTSearchForPanel.
	cheatSheet := self instantiate: RTCheatSheetPresenter.
	searchButton := self newButton.
	searchButton
		icon: (self iconNamed: #smallFind);
		label: 'Find ocurrences'.
	self initializeLayout
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

	patternCodePresenter lhs: aString
]

{ #category : #action }
RTExpressionFinderPresenter >> searchExpression [

	| methods ruleHolder critiques |
	methods := (RPackage organizer packages flatCollect: #classes) 
		           flatCollect: #methods.
	ruleHolder := RTRuleHolder
		lhs: patternCodePresenter lhs
		rhs: ''.		

	critiques := RTRenrakuApplier
		obtainCritiquesOf: methods
		forRules: { ruleHolder }.
	^ (RTOccurrencesBrowserPresenter critiques: critiques) open
]
