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
MatchToolPresenterTest >> testBindingsTableContainsMatchings [

	"First, we match a pattern with a corresponding Pharo code. This will populate MatchToolPresenter 	tables with the matches."

	self matchPatternWithCode.
	"Now, we simulate the click on the first item of the match table for populate the bindings table 	because that table is empty until is clicked. "
	matchToolPresenter matchesList clickAtIndex: 1.
	"Check if the bindings table have the two corresponding items."
	self assert: matchToolPresenter bindingsTable items size equals: 2.
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
MatchToolPresenterTest >> testIconWasAddedToTheme [

	| icon |
	icon := self iconNamed: #jigsawIcon.
	self deny: icon equals: (self iconNamed: #blackIcon)
]

{ #category : #tests }
MatchToolPresenterTest >> testMatchToolOpens [

	| matchToolWindow |
	matchToolWindow := MatchToolPresenter open.
	self assert: matchToolWindow isBuilt.
	matchToolWindow window close
]

{ #category : #tests }
MatchToolPresenterTest >> testMatchingTableContainsMatchings [

	"First, we match a pattern with a corresponding Pharo code. This will populate MatchToolPresenter 	tables with the matches."

	self matchPatternWithCode.
	"Check if the matching table has two elements and the elements are the correct matches."
	self assert: matchToolPresenter matchesList items size equals: 2.
	self
		assert:
		(matchToolPresenter matchesList items at: 1) key formattedCode
		equals: 'a = b ifTrue: [ x = y ifTrue: [ aBlock ] ]'.
	self
		assert:
		(matchToolPresenter matchesList items at: 2) key formattedCode
		equals: 'x = y ifTrue: [ aBlock ]'
]
