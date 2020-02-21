"
A root of all MatchTool edit modes. (all for highlighting different codes)
"
Class {
	#name : #MchToolMode,
	#superclass : #RubSmalltalkCodeMode,
	#category : #'MatchTool-Styling'
}

{ #category : #accessing }
MchToolMode >> interactive [
	^ true
]

{ #category : #helper }
MchToolMode >> restyleTextArea [

	self textArea
		restoreSelectionIndexesAfter: [ 
			| t |
			t := self textArea text copy.
			self textArea updateTextWith: ''.
			self textArea updateTextWith: t ]
]

{ #category : #'initialize-release' }
MchToolMode >> updateTextAreaWhenPlugged [
	self withShoutStyler.
	self textArea shoutStyler beForMatchTool.
]
