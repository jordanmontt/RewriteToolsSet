"
I am a command that opens the applier presenter.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #OpenRTApplierCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTApplierCommand class >> defaultDescription [

	^ 'Open a tool to apply a saved rewrite rule to a selected set of classes.'
]

{ #category : #default }
OpenRTApplierCommand class >> defaultName [

	^ 'Transform selection...'
]

{ #category : #default }
OpenRTApplierCommand class >> iconName [

	^ RTRuleTransformerPresenter iconName
]

{ #category : #executing }
OpenRTApplierCommand >> execute [

	^ RTRuleTransformerPresenter open
]
