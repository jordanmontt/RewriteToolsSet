"
Style code as pattern-based expression
"
Class {
	#name : #MachToolMatchExpressionMode,
	#superclass : #MachToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MachToolMatchExpressionMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.
	self textArea shoutStyler styler
		beForMatchCode;
		beForExpression.
		
	self restyleTextArea.
]
