"
I am an application to use in all RT tool to define costum styles.
"
Class {
	#name : #RTApplication,
	#superclass : #SpApplication,
	#category : #'RewriteRuleTools-Application'
}

{ #category : #running }
RTApplication >> start [

	(self newPresenter: RTRuleEditorPresenter) openWithSpec
]

{ #category : #running }
RTApplication >> startExpressionFinder [

	^ (self newPresenter: RTExpressionFinderPresenter) open
]

{ #category : #running }
RTApplication >> startHelpBrowser [

	^ (self newPresenter: RTHelpBrowserPresenter) open
]

{ #category : #running }
RTApplication >> startMatchTool [

	^ (self newPresenter: MatchToolPresenter) open
]

{ #category : #running }
RTApplication >> startRuleEditor [

	^ (self newPresenter: RTRuleEditorPresenter) open
]

{ #category : #running }
RTApplication >> startRuleLoader [

	^ (self newPresenter: RTRuleLoaderPresenter) open
]

{ #category : #styling }
RTApplication >> styleSheet [

	^ SpStyle defaultStyleSheet, 
	(SpStyleVariableSTONReader fromString:
'.application [
	
	.container [ Container { #padding: 4, #borderWidth: 2 } ],
	.bgOpaque [ Draw { #backgroundColor: EnvironmentColor(#base) } ],
	.bgBlue [ Draw { #backgroundColor: #blue } ],
	.boldFont [ Font { #bold: true } ],
	.textFont [ Font { #name: EnvironmentFont(#default) } ],
	.bigFontSize [ Font { #size: 20 } ],
	.buttonStyle [ Geometry { #width: 130 } ]
]')
]
