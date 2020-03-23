"
Style code as smalltalk expression
"
Class {
	#name : #MchToolCodeExpressionMode,
	#superclass : #MchToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MchToolCodeExpressionMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.
	
	self textArea shoutStyler styler
		beForSmalltalkCode;
		beForExpression.
		
	self restyleTextArea.
]
