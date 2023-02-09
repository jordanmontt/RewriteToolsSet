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

{ #category : #layout }
RTExpressionFinderPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		add: patternCodePresenter;
		add: (SpBoxLayout newTopToBottom
			add: cheatSheet expand: true;
			add: searchButton expand: false;
			add: searchOnAllClassesButton expand: false;
			yourself);
		positionOfSlider: 70 percent;
		yourself
]

{ #category : #initialization }
RTExpressionFinderPresenter >> initializePresenters [

	patternCodePresenter := self instantiate: RTSearchForPanel.
	cheatSheet := self instantiate: RTCheatSheetPresenter.
	scopeSelectorPresenter := self instantiate: ScopeSelectorPresenter.
	searchButton := self newButton
		iconName: #smallFind;
		label: 'Find in all classes';
		yourself.
	searchOnAllClassesButton := self newButton
		iconName: #smallFind;
		label: 'Find in selected classes';
		yourself
]

{ #category : #initialization }
RTExpressionFinderPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 600 @ 330;
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
	self flag: 'Need to refactor this we should get the methods from a class not calculate them our selves.'.
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
	self flag: 'This logic should be in the applier class'.
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
