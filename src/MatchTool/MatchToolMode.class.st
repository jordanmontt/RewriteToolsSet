"
A root of all MatchTool edit modes. (all for highlighting different codes)
"
Class {
	#name : #MatchToolMode,
	#superclass : #RubSmalltalkCodeMode,
	#category : #'MatchTool-Styling'
}

{ #category : #accessing }
MatchToolMode >> interactive [
	^ true
]

{ #category : #helper }
MatchToolMode >> restyleTextArea [

	self textArea
		restoreSelectionIndexesAfter: [ 
			| t |
			t := self textArea text copy.
			self textArea updateTextWith: ''.
			self textArea updateTextWith: t ]
]

{ #category : #'initialize-release' }
MatchToolMode >> updateTextAreaWhenPlugged [

	self withShoutStyler.
	self textArea shoutStyler beForMatchTool.
]
