"
I am a subclass of `SpCodePresenter`. Besides of the functionality of the SpCodePresenter, I have an AST which is the code parsed. Also, I can return the current selected code as a node.
 
- ast: an AST of current source code

"
Class {
	#name : #RRCodePresenter,
	#superclass : #SpCodePresenter,
	#instVars : [
		'ast'
	],
	#category : #'RewriteTool-Models'
}

{ #category : #accessing }
RRCodePresenter >> ast [
	^ ast
]

{ #category : #accessing }
RRCodePresenter >> ast: anAST [

	ast := anAST.
	self text: ast formattedCode
]

{ #category : #accessing }
RRCodePresenter >> getSelectedNode [

	^ self ast bestNodeFor:
		  (self selectionInterval first + 1 to:
		   self selectionInterval last - 1)
]
