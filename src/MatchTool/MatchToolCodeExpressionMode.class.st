"
Style code as smalltalk expression
"
Class {
	#name : #MatchToolCodeExpressionMode,
	#superclass : #MatchToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MatchToolCodeExpressionMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.
	
	self textArea shoutStyler styler
		beForSmalltalkCode;
		beForExpression.
		
	self restyleTextArea.
]
