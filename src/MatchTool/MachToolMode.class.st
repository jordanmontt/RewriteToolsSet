"
A root of all MatchTool edit modes. (all for highlighting different codes)
"
Class {
	#name : #MachToolMode,
	#superclass : #RubSmalltalkCodeMode,
	#category : #'MatchTool-Styling'
}

{ #category : #accessing }
MachToolMode >> interactive [
	^ true
]

{ #category : #helper }
MachToolMode >> restyleTextArea [

	self textArea
		restoreSelectionIndexesAfter: [ 
			| t |
			t := self textArea text copy.
			self textArea updateTextWith: ''.
			self textArea updateTextWith: t ]
]

{ #category : #'initialize-release' }
MachToolMode >> updateTextAreaWhenPlugged [

	self withShoutStyler.
	self textArea shoutStyler beForMatchTool.
]
