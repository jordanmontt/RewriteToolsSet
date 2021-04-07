"
A RewriteRulesHelpPresenterTest is a test class for testing the behavior of RewriteRulesHelpPresenter
"
Class {
	#name : #RewriteRulesHelpPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'rulesHelper'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RewriteRulesHelpPresenterTest >> setUp [

	super setUp.

	rulesHelper := RewriteRulesHelpPresenter new
]

{ #category : #test }
RewriteRulesHelpPresenterTest >> testCreateTextMorph [

	| morph |
	morph := rulesHelper createTextMorph.
	self assert: (morph isMemberOf: RubScrolledTextMorph)
]

{ #category : #test }
RewriteRulesHelpPresenterTest >> testOpen [

	| window |
	window := rulesHelper class open.
	self assert: window isBuilt.
	window close
]

{ #category : #test }
RewriteRulesHelpPresenterTest >> testgetMicrodownParsedText [

	| aText |
	aText := rulesHelper class getMicrodownParsedText.
	self assert: (aText isMemberOf: Text)
]
