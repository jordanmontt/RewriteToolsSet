"
Style code as pattern-based method
"
Class {
	#name : #MachToolMatchMethodMode,
	#superclass : #MachToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MachToolMatchMethodMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.
	self textArea shoutStyler styler
		beForMatchCode;
		beForMethod.
		
	self restyleTextArea.
]
