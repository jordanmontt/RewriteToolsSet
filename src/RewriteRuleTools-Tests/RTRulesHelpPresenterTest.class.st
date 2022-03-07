"
A RewriteRulesHelpPresenterTest is a test class for testing the behavior of RewriteRulesHelpPresenter
"
Class {
	#name : #RTRulesHelpPresenterTest,
	#superclass : #RTAbstractToolTest,
	#instVars : [
		'rulesHelper'
	],
	#category : #'RewriteRuleTools-Tests-HelpBrowser'
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
	aText := rulesHelper class getParsedText.
	self assert: aText isNotEmpty
]

{ #category : #accessing }
RTRulesHelpPresenterTest >> toolClass [

	^ RTRuleLoaderPresenter
]
