"
style code as Smalltalk method
"
Class {
	#name : #MchToolCodeMethodMode,
	#superclass : #MchToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MchToolCodeMethodMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.

	self textArea shoutStyler styler
		beForSmalltalkCode;
		beForMethod.
		
	self restyleTextArea.
]
