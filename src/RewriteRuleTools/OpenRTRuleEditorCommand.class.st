"
I am a command that opens the rt basic editor presenter from another presenter keeping the same code.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #OpenRTRuleEditorCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTRuleEditorCommand class >> defaultDescription [

	^ 'Open Rewrite Rule Editor'
]

{ #category : #default }
OpenRTRuleEditorCommand class >> defaultName [

	^ 'Open Rule Editor'
]

{ #category : #default }
OpenRTRuleEditorCommand class >> iconName [

	^RTRuleEditorPresenter iconName
]

{ #category : #executing }
OpenRTRuleEditorCommand >> execute [

	| window |
	window := RTApplication new startRuleEditor.
	window presenter
		lhs: self context lhs;
		rhs: self context rhs.
	^ window
]
