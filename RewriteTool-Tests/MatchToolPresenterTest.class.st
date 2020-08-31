Class {
	#name : #MatchToolPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'matchToolPresenter'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #defaults }
MatchToolPresenterTest >> matchPatternWithCode [

	| pattern code |
	pattern := '`@expression ifTrue: [ `@codeBlock ]'.
	code := 'a = b ifTrue: [ 
	x = y ifTrue: [ aBlock ] ]'.
	matchToolPresenter codeEditor text: code.
	matchToolPresenter ruleEditor text: pattern.
	matchToolPresenter performMatching
]

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

	self matchPatternWithCode.
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
MatchToolPresenterTest >> testMatchingTableContainsMatchings [

	"This test tests is the matching table was populated with the correct matchings.
	First, we match a pattern with a corresponding Pharo code. This will populate MatchToolPresenter 	tables with the matches."

	self matchPatternWithCode.
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

{ #category : #tests }
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

{ #category : #tests }
MatchToolPresenterTest >> testPerformMatching [

	"This test tests if the match lists contain the adequate number of matching. The other tests see if the tables are populated correctly."

	self matchPatternWithCode.
	self assert: matchToolPresenter matchesList items size equals: 2.
	matchToolPresenter matchesList clickAtIndex: 1.
	self assert: matchToolPresenter bindingsTable items size equals: 2
]
