Class {
	#name : #MatchToolPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'matchToolPresenter'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
MatchToolPresenterTest >> setUp [

	super setUp.
	matchToolPresenter := MatchToolPresenter new
]

{ #category : #test }
MatchToolPresenterTest >> testAddIconToTheme [

	| icon |
	icon := self iconNamed: #jigsawIcon.
	self deny: icon equals: (self iconNamed: #blackIcon)
]

{ #category : #test }
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

{ #category : #test }
MatchToolPresenterTest >> testEmptyLists [

	matchToolPresenter emptyLists.
	self assertEmpty: matchToolPresenter bindingsTable items.
	self assertEmpty: matchToolPresenter matchesList items
]

{ #category : #test }
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

{ #category : #test }
MatchToolPresenterTest >> testInitializePresenters [

	self assert: matchToolPresenter methodCheckbox isNotNil.
	self assert: matchToolPresenter ruleEditor isNotNil.
	self assert: matchToolPresenter codeEditor isNotNil.
	self assert: matchToolPresenter matchesList isNotNil.
	self assert: matchToolPresenter bindingsTable isNotNil.
	self assert: matchToolPresenter codeEditor text isNotNil.
	self assert: matchToolPresenter ruleEditor text isNotNil
]

{ #category : #test }
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

{ #category : #test }
MatchToolPresenterTest >> testMatchesChanged [

	matchToolPresenter matchesChanged.
	self assertEmpty: matchToolPresenter bindingsTable items
]

{ #category : #test }
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

{ #category : #test }
MatchToolPresenterTest >> testOpen [

	| matchToolWindow |
	matchToolWindow := MatchToolPresenter open.
	self assert: matchToolWindow isBuilt.
	matchToolWindow close
]

{ #category : #test }
MatchToolPresenterTest >> testParseCodeAST [

	| code methodCode |
	code := '| aNumber |
aNumber ifNil: [ ^ self ].
aNumber := 5.'.
	methodCode := 'calculate
| aNumber |
aNumber ifNil: [ ^ self ].
aNumber := 5.'.
	matchToolPresenter codeEditor text: code.
	matchToolPresenter parseCodeAST.
	self
		assert: matchToolPresenter astCode
		equals: (RBParser parseExpression: code).
	matchToolPresenter codeEditor text: methodCode.
	matchToolPresenter methodCheckbox click.
	matchToolPresenter parseCodeAST.
	self
		assert: matchToolPresenter astCode
		equals: (RBParser parseMethod: methodCode)
]

{ #category : #test }
MatchToolPresenterTest >> testParsePatternAST [

	| rule methodRule |
	rule := '| `object |
`object ifNil: [ ^ self ].
`.Statement.'.
	methodRule := '`aMethod
| `object |
`object ifNil: [ ^ self ].
`.Statement.'.
	matchToolPresenter ruleEditor text: rule.
	matchToolPresenter parsePatternAST.
	self
		assert: matchToolPresenter astPattern
		equals: (RBPatternParser parseExpression: rule).
	matchToolPresenter ruleEditor text: methodRule.
	matchToolPresenter methodCheckbox click.
	matchToolPresenter parsePatternAST.
	self
		assert: matchToolPresenter astPattern
		equals: (RBPatternParser parseMethod: methodRule)
]

{ #category : #test }
MatchToolPresenterTest >> testPatternCode [

	matchToolPresenter patternCode: '`var'.
	self assert: matchToolPresenter patternCode equals: '`var'
]

{ #category : #test }
MatchToolPresenterTest >> testPerformMatching [

	"This test tests if the match lists contain the adequate number of matching. The other tests see if the tables are populated correctly."

	matchToolPresenter
		pharoCode: 'a = b ifTrue: [ x = y ifTrue: [ aBlock ] ]';
		patternCode: '`@expression ifTrue: [ `@codeBlock ]'.
	matchToolPresenter performMatching.
	self assert: matchToolPresenter matchesList items size equals: 2.
	self assert: matchToolPresenter astCode isNotNil.
	self assert: matchToolPresenter astPattern isNotNil.
	matchToolPresenter matchesList clickAtIndex: 1.
	self assert: matchToolPresenter bindingsTable items size equals: 2
]

{ #category : #test }
MatchToolPresenterTest >> testPharoCode [

	matchToolPresenter pharoCode: 'OrderedCollection new'.
	self
		assert: matchToolPresenter pharoCode
		equals: 'OrderedCollection new'
]
