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

	rulesHelper := RTHelpBrowserPresenter new
]

{ #category : #tests }
RTRulesHelpPresenterTest >> testCreateTextMorph [

	| morph |
	morph := rulesHelper createTextMorph.
	self assert: (morph isMemberOf: RubScrolledTextMorph)
]

{ #category : #tests }
RTRulesHelpPresenterTest >> testGetMicrodownParsedText [

	| aText |
	aText := rulesHelper class getMicrodownParsedText.
	self assert: (aText isMemberOf: Text)
]

{ #category : #tests }
RTRulesHelpPresenterTest >> testOpen [

	| window |
	window := rulesHelper class open.
	self assert: window isBuilt.
	window close
]
