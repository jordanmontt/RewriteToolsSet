"
A RTHelpBrowserPresenterTest is a test class for testing the behavior of RTHelpBrowserPresenter
"
Class {
	#name : #RTHelpBrowserPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'helpBrowser'
	],
	#category : #'RewriteTools-Tests'
}

{ #category : #running }
RTHelpBrowserPresenterTest >> setUp [

	super setUp.
	helpBrowser := RTHelpBrowserPresenter new
]

{ #category : #running }
RTHelpBrowserPresenterTest >> testOpen [

	| window |
	window := helpBrowser open.
	self assert: window isBuilt.
	
	window close
]
