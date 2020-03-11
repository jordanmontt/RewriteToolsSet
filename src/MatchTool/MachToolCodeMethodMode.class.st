"
style code as Smalltalk method
"
Class {
	#name : #MachToolCodeMethodMode,
	#superclass : #MachToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MachToolCodeMethodMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.

	self textArea shoutStyler styler
		beForSmalltalkCode;
		beForMethod.
		
	self restyleTextArea.
]
