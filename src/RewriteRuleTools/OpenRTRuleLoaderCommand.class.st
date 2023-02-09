"
I am a command that open the rt rule loader presenter from another presenter.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #OpenRTRuleLoaderCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTRuleLoaderCommand class >> defaultDescription [

	^ 'Load an example Rewrite Rule'
]

{ #category : #default }
OpenRTRuleLoaderCommand class >> defaultName [

	^ 'Load an example rule'
]

{ #category : #default }
OpenRTRuleLoaderCommand class >> iconName [

	^ RTRuleLoaderPresenter iconName
]

{ #category : #executing }
OpenRTRuleLoaderCommand >> execute [

	| window |
	window := RTApplication new startRuleLoader.
	^ window
]
