"
A SourcePanel is a subclass of AbstractPanel.
Holds source code of expression that should be transformed into something new.
Located in top left part of RewriteRuleBuilder.
"
Class {
	#name : #SourcePanelPresenter,
	#superclass : #AbstractPanelPresenter,
	#category : #'RewriteTool-Panels'
}

{ #category : #actions }
SourcePanelPresenter >> change [
	| newSource oldNode newNode oldAst |
	oldAst := textModel ast copy.
	oldNode := textModel getSelectedNode.
	newSource := UIManager default
		request: 'Enter new source instead of: ' , textModel getSelectedNode formattedCode
		initialAnswer: ''.
	(newSource = '' or: [ newSource isNil ])
		ifTrue: [ self changeInvalidAlert ]
		ifFalse: [ 
			textModel ast allChildren
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
SourcePanelPresenter >> menuActions [
	| options |
	options := OrderedCollection new.
	textModel getSelectedNode isInTemporariesList
		ifFalse: [ options add: #('Change' #change) ].
	^ options
]
