"
I am a command that opens the rt basic editor presenter from another presenter keeping the same code.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #OpenRTBasicEditorCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTBasicEditorCommand class >> defaultName [

	^ 'Rule editor'
]

{ #category : #default }
OpenRTBasicEditorCommand class >> iconName [

	^RTBasicEditorPresenter iconName
]

{ #category : #executing }
OpenRTBasicEditorCommand >> execute [

	^ RTBasicEditorPresenter new
		lhs: self context lhs;
		rhs: self context rhs;
		openWithSpec
]
