"
I am an application to use in all RT tool to define costum styles.
"
Class {
	#name : #RTApplication,
	#superclass : #SpApplication,
	#classVars : [
		'Current'
	],
	#category : #'RewriteRuleTools-Application'
}

{ #category : #accessing }
RTApplication class >> current [

	^ Current ifNil: [ Current := self new ]
]

{ #category : #running }
RTApplication >> start [

	(self newPresenter: RTRuleEditorPresenter) openWithSpec
]

{ #category : #running }
RTApplication >> startExpressionFinder [

	^ (self newPresenter: RTExpressionFinderPresenter) openWithSpec
]

{ #category : #running }
RTApplication >> startHelpBrowser [

	^ (self newPresenter: RTHelpBrowserPresenter) openWithSpec
]

{ #category : #running }
RTApplication >> startMatchTool [

	^ (self newPresenter: MatchToolPresenter) openWithSpec
]

{ #category : #running }
RTApplication >> startRuleBuilder [

	^ (self newPresenter: RewriteRuleBuilderPresenter) openWithSpec
]

{ #category : #running }
RTApplication >> startRuleEditor [

	^ (self newPresenter: RTRuleEditorPresenter) openWithSpec
]

{ #category : #running }
RTApplication >> startRuleLoader [

	^ (self newPresenter: RTRuleLoaderPresenter) openWithSpec
]

{ #category : #running }
RTApplication >> startTransformer [

	^ (self newPresenter: RTCodeTransformerPresenter) openWithSpec
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
