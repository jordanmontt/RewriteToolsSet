"
Style code as pattern-based method
"
Class {
	#name : #MchToolMatchMethodMode,
	#superclass : #MchToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MchToolMatchMethodMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.
	self textArea shoutStyler styler
		beForMatchCode;
		beForMethod.
		
	self restyleTextArea.
]
