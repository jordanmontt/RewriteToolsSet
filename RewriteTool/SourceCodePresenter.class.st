"
A SourcePanel is a subclass of AbstractPanel.
Holds source code of expression that should be transformed into something new.
Located in top left part of RewriteRuleBuilder.
"
Class {
	#name : #SourceCodePresenter,
	#superclass : #AbstractRuleCodePresenter,
	#category : #'RewriteTool-SharedPresenters'
}

{ #category : #actions }
SourceCodePresenter >> change [
	| newSource oldNode newNode oldAst |
	oldAst := codePresenter ast copy.
	oldNode := codePresenter getSelectedNode.
	newSource := UIManager default
		request:
			'Enter new source instead of: '
				, codePresenter getSelectedNode formattedCode
		initialAnswer: ''.
	(newSource = '' or: [ newSource isNil ])
		ifTrue: [ self changeInvalidAlert ]
		ifFalse: [ codePresenter ast allChildren
				do: [ :each | 
					each = oldNode
						ifTrue: [ each
								command: (RenameCommand receiver: each panel: self withSource: newSource).
							newNode := each command execute ] ] ].
	self flag: #accesOwner.
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
SourceCodePresenter >> initializePresenters [
	super initializePresenters.
	label label: 'Source code:'
]

{ #category : #initialization }
SourceCodePresenter >> menuActions [
	| options |
	options := OrderedCollection new.
	codePresenter getSelectedNode isInTemporariesList
		ifFalse: [ options add: #('Change' #change) ].
	^ options
]
