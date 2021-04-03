"
An UndoOnNodeCommand is command that reverts previous change only on selected node.

"
Class {
	#name : #UndoOnNodeCommand,
	#superclass : #Command,
	#category : #'RewriteRuleBuilder-Command'
}

{ #category : #execute }
UndoOnNodeCommand >> execute [
	| newNode |
	newNode := commandReceiver oldNodes removeLast.
	self changeCommandReceiverFor: newNode.
	^ newNode
]
