"
style code as Smalltalk method
"
Class {
	#name : #MatchToolCodeMethodMode,
	#superclass : #MatchToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MatchToolCodeMethodMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.

	self textArea shoutStyler styler
		beForSmalltalkCode;
		beForMethod.
		
	self restyleTextArea.
]
