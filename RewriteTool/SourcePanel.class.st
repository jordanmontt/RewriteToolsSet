"
A SourcePanel is a subclass of AbstractPanel.
Holds source code of expression that should be transformed into something new.
Located in top left part of RewriteRuleBuilder.
"
Class {
	#name : #SourcePanel,
	#superclass : #AbstractPanel,
	#category : #'RewriteTool-Panels'
}

{ #category : #actions }
SourcePanel >> change [
	| newSource oldNode newNode oldAst |
	oldAst := self textModel ast copy.
	oldNode := self textModel getSelectedNode.
	newSource := UIManager default
		request: 'Enter new source instead of: ' , self textModel getSelectedNode formattedCode
		initialAnswer: ''.
	(newSource = '' or: [ newSource isNil ])
		ifTrue: [ self changeInvalidAlert ]
		ifFalse: [ 
			self textModel ast allChildren
				do: [ :each | 
					each = oldNode
						ifTrue: [ 
							each command: (RenameCommand receiver: each panel: self withSource: newSource).
							newNode := each command execute ] ] ].
	self owner transformationRule undoDict
		add:
			(RewriteRuleChange new
				panel: self asOrderedCollection;
				ast: oldAst asOrderedCollection;
				yourself).
	self owner transformationRule undoButton enable.
	self updateTextAndAst.
	self owner sourcePanelChangedUpdateAfter
]

{ #category : #initialization }
SourcePanel >> menuActions [
	| options |
	options := OrderedCollection new.
	self textModel getSelectedNode isInTemporariesList
		ifFalse: [ options add: #('Change' #change) ].
	^ options
]
