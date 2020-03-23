"
Style code as pattern-based expression
"
Class {
	#name : #MchToolMatchExpressionMode,
	#superclass : #MchToolMode,
	#category : #'MatchTool-Styling'
}

{ #category : #'initialize-release' }
MchToolMatchExpressionMode >> updateTextAreaWhenPlugged [
	super updateTextAreaWhenPlugged.
	self textArea shoutStyler styler
		beForMatchCode;
		beForExpression.
		
	self restyleTextArea.
]
