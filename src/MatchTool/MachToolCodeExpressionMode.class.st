"
Style code as smalltalk expression
"
Class {
	#name : #MachToolCodeExpressionMode,
	#superclass : #MachToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MachToolCodeExpressionMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.
	
	self textArea shoutStyler styler
		beForSmalltalkCode;
		beForExpression.
		
	self restyleTextArea.
]
