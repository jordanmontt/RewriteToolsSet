"
I am a presenter that finds all the ocurrenses of a pattern code in all the methods that are in the Pharo image.
"
Class {
	#name : #RTExpressionFinderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'patternCodePresenter',
		'searchButton',
		'cheatSheet',
		'searchOnAllClassesButton',
		'scopeSelectorPresenter'
	],
	#category : #'RewriteRuleTools-ExpressionFinder'
}

{ #category : #'world menu' }
RTExpressionFinderPresenter class >> descriptionText [

	^ 'A tool to search the ocurrences of a rewrite rule within the Pharo image'
]

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
	(aBuilder item: 'Expression Finder')
		action: [ RTApplication new startExpressionFinder ];
		order: 31;
		parent: #Tools;
		icon: self icon;
		help: self descriptionText
]

{ #category : #specs }
RTExpressionFinderPresenter class >> title [

	^ 'Expression Finder'
]

{ #category : #initialization }
RTExpressionFinderPresenter >> connectPresenters [

	searchButton action: [ self searchExpression ].
	
	searchOnAllClassesButton action: [ self searchExpressionOnAllClasses ]
]

{ #category : #initialization }
RTExpressionFinderPresenter >> initializeLayout [

	| tempLayout |
	tempLayout := SpPanedLayout newLeftToRight
		add: patternCodePresenter;
		add: (SpBoxLayout newTopToBottom
			add: cheatSheet expand: true;
			add: searchButton expand: false;
			add: searchOnAllClassesButton expand: false;
			yourself);
		positionOfSlider: 70 percent;
		yourself.

	self layout: tempLayout
]

{ #category : #initialization }
RTExpressionFinderPresenter >> initializePresenters [
	
	patternCodePresenter := self instantiate: RTSearchForPanel.
	
	cheatSheet := self instantiate: RTCheatSheetPresenter.
	
	scopeSelectorPresenter := self instantiate: ScopeSelectorPresenter.
	
	searchButton := self newButton.
	searchButton
		iconName: #smallFind;
		label: 'Find in all classes'.
	
	searchOnAllClassesButton := self newButton.
	searchOnAllClassesButton
		iconName: #smallFind;
		label: 'Find in selected classes'.

	self initializeLayout
]

{ #category : #initialization }
RTExpressionFinderPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 550 @ 330;
		windowIcon: self class icon;
		askOkToClose: false
]

{ #category : #accessing }
RTExpressionFinderPresenter >> patternCode [
	^ patternCodePresenter lhs
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

{ #category : #action }
RTExpressionFinderPresenter >> searchExpressionOnAllClasses [

	| dialogWindow methods ruleHolder critiques |
	dialogWindow := scopeSelectorPresenter openAsDialog.
	
	dialogWindow okAction: [ 
		methods := scopeSelectorPresenter selectedClasses
			flatCollectAsSet: [ :each | each methods ].
		ruleHolder := RTRuleHolder
			lhs: patternCodePresenter lhs
			rhs: ''.
	
		critiques := RTRenrakuApplier
			obtainCritiquesOf: methods
			forRules: { ruleHolder }.

		(RTOccurrencesBrowserPresenter critiques: critiques) open ].
]
