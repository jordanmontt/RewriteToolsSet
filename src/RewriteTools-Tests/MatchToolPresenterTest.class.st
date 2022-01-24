Class {
	#name : #MatchToolPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'matchToolPresenter'
	],
	#category : #'RewriteTools-Tests'
}

{ #category : #running }
MatchToolPresenterTest >> setUp [

	super setUp.
	matchToolPresenter := MatchToolPresenter new
]

{ #category : #tests }
MatchToolPresenterTest >> testAddIconToTheme [

	| icon |
	icon := self iconNamed: #jigsawIcon.
	self deny: icon equals: (self iconNamed: #blackIcon)
]

{ #category : #tests }
MatchToolPresenterTest >> testBindingsTableContainsMatchings [

	"This test tests is the bindings table was populated with the correct matchings.
	First, we match a pattern with a corresponding Pharo code. This will populate MatchToolPresenter 	tables with the matches."

	matchToolPresenter
		pharoCode: 'a = b ifTrue: [ x = y ifTrue: [ aBlock ] ]';
		patternCode: '`@expression ifTrue: [ `@codeBlock ]'.
	matchToolPresenter performMatching.
	"Now, we simulate the click on the first item of the match table for populate the bindings table 	because that table is empty until is clicked."
	matchToolPresenter matchesList clickAtIndex: 1.
	"Finally, check if the items in the bindigs table are correct. Remember that the bindings table 	have two columns: pattern and match. So, we have to assert four times."
	self
		assert:
		(matchToolPresenter bindingsTable items at: 1) key formattedCode
		equals: '`@expression'.
	self
		assert:
		(matchToolPresenter bindingsTable items at: 1) value formattedCode
		equals: 'a = b'.
	self
		assert:
		(matchToolPresenter bindingsTable items at: 2) key formattedCode
		equals: '`@codeBlock'.
	self
		assert:
		(matchToolPresenter bindingsTable items at: 2) value formattedCode
		equals: 'x = y ifTrue: [ aBlock ]'
]

{ #category : #tests }
MatchToolPresenterTest >> testEmptyLists [

	matchToolPresenter emptyLists.
	self assertEmpty: matchToolPresenter bindingsTable items.
	self assertEmpty: matchToolPresenter matchesList items
]

{ #category : #tests }
MatchToolPresenterTest >> testGetBindingsItemsForMatch [

	| match |
	matchToolPresenter
		patternCode: '`var';
		pharoCode: 'var'.
	matchToolPresenter performMatching.
	match := matchToolPresenter matchesList items first value.
	self denyEmpty: (matchToolPresenter getBindingsItemsForMatch: match).
	matchToolPresenter
		patternCode: '';
		pharoCode: ''.
	matchToolPresenter performMatching.
	match := matchToolPresenter matchesList items first value.
	self assertEmpty:
		(matchToolPresenter getBindingsItemsForMatch: match)
]

{ #category : #tests }
MatchToolPresenterTest >> testInitializePresenters [

	self assert: matchToolPresenter methodCheckbox class equals: SpCheckBoxPresenter.
	self assert: matchToolPresenter ruleEditor class equals: RTSearchForPanel.
	self assert: matchToolPresenter codeEditor class equals: SpCodePresenter.
	self assert: matchToolPresenter matchesList class equals: SpListPresenter.
	self assert: matchToolPresenter bindingsTable class equals: SpTablePresenter.
	self assert: matchToolPresenter codeEditor text isNotEmpty.
	self assert: matchToolPresenter ruleEditor lhs isNotEmpty
]

{ #category : #tests }
MatchToolPresenterTest >> testMatchMethod [

	matchToolPresenter
		patternCode: '`method `var';
		pharoCode: 'aMethod var'.
	matchToolPresenter methodCheckbox click.
	matchToolPresenter performMatching.
	matchToolPresenter matchesList clickAtIndex: 1.
	self
		assert: (matchToolPresenter matchesList items at: 1) key source
		equals: 'aMethod var'.
	self
		assert: (matchToolPresenter bindingsTable items at: 1) value
		equals: 'aMethod var'.
	self
		assert: (matchToolPresenter bindingsTable items at: 2) value
		equals: 'aMethod'.
	self
		assert:
		(matchToolPresenter bindingsTable items at: 4) key formattedCode
		equals: '`var'.
	self
		assert:
		(matchToolPresenter bindingsTable items at: 4) value formattedCode
		equals: 'var'
]

{ #category : #tests }
MatchToolPresenterTest >> testMatchesChanged [

	matchToolPresenter matchesChanged.
	self assertEmpty: matchToolPresenter bindingsTable items
]

{ #category : #tests }
MatchToolPresenterTest >> testMatchingTableContainsMatchings [

	"This test tests is the matching table was populated with the correct matchings.
	First, we match a pattern with a corresponding Pharo code. This will populate MatchToolPresenter 	tables with the matches."

	matchToolPresenter
		pharoCode: 'a = b ifTrue: [ x = y ifTrue: [ aBlock ] ]';
		patternCode: '`@expression ifTrue: [ `@codeBlock ]'.
	matchToolPresenter performMatching.
	self
		assert:
		(matchToolPresenter matchesList items at: 1) key formattedCode
		equals: 'a = b ifTrue: [ x = y ifTrue: [ aBlock ] ]'.
	self
		assert:
		(matchToolPresenter matchesList items at: 2) key formattedCode
		equals: 'x = y ifTrue: [ aBlock ]'
]

{ #category : #tests }
MatchToolPresenterTest >> testPatternCode [

	matchToolPresenter patternCode: '`var'.
	self assert: matchToolPresenter patternCode equals: '`var'
]

{ #category : #tests }
MatchToolPresenterTest >> testPerformMatching [

	"This test tests if the match lists contain the adequate number of matching. The other tests see if the tables are populated correctly."

	matchToolPresenter
		pharoCode: 'a = b ifTrue: [ x = y ifTrue: [ aBlock ] ]';
		patternCode: '`@expression ifTrue: [ `@codeBlock ]'.
	matchToolPresenter performMatching.
	self assert: matchToolPresenter matchesList items size equals: 2.
	matchToolPresenter matchesList clickAtIndex: 1.
	self assert: matchToolPresenter bindingsTable items size equals: 2
]

{ #category : #tests }
MatchToolPresenterTest >> testPharoCode [

	matchToolPresenter pharoCode: 'OrderedCollection new'.
	self
		assert: matchToolPresenter pharoCode
		equals: 'OrderedCollection new'
]
