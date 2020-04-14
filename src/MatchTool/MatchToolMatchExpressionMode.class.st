"
Style code as pattern-based expression
"
Class {
	#name : #MatchToolMatchExpressionMode,
	#superclass : #MatchToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MatchToolMatchExpressionMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.
	self textArea shoutStyler styler
		beForMatchCode;
		beForExpression.
		
	self restyleTextArea.
]
