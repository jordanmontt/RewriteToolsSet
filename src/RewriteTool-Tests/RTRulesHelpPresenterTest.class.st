"
A RewriteRulesHelpPresenterTest is a test class for testing the behavior of RewriteRulesHelpPresenter
"
Class {
	#name : #RTRulesHelpPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'rulesHelper'
	],
	#category : #'RewriteTool-Tests'
}

{ #category : #running }
RTRulesHelpPresenterTest >> setUp [

	super setUp.

	rulesHelper := RTRulesHelpPresenter new
]

{ #category : #tests }
RTRulesHelpPresenterTest >> testCreateTextMorph [

	| morph |
	morph := rulesHelper createTextMorph.
	self assert: (morph isMemberOf: RubScrolledTextMorph)
]

{ #category : #tests }
RTRulesHelpPresenterTest >> testOpen [

	| window |
	window := rulesHelper class open.
	self assert: window isBuilt.
	window close
]

{ #category : #tests }
RTRulesHelpPresenterTest >> testgetMicrodownParsedText [

	| aText |
	aText := rulesHelper class getMicrodownParsedText.
	self assert: (aText isMemberOf: Text)
]
