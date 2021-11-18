"
I am a command that opens the applier presenter.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #OpenRTTransformerCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTTransformerCommand class >> defaultDescription [

	^ 'Open a tool to apply a saved rewrite rule to a selected set of classes.'
]

{ #category : #default }
OpenRTTransformerCommand class >> defaultName [

	^ 'Transform selection...'
]

{ #category : #default }
OpenRTTransformerCommand class >> iconName [

	^ RTCodeTransformerPresenter iconName
]

{ #category : #executing }
OpenRTTransformerCommand >> execute [

	^ RTCodeTransformerPresenter open
]
