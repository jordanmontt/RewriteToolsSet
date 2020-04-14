"
Style code as pattern-based method
"
Class {
	#name : #MatchToolMatchMethodMode,
	#superclass : #MatchToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MatchToolMatchMethodMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.
	self textArea shoutStyler styler
		beForMatchCode;
		beForMethod.
		
	self restyleTextArea.
]
