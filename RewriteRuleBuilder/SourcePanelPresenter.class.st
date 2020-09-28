"
A SourcePanel is a subclass of AbstractPanel.
Holds source code of expression that should be transformed into something new.
Located in top left part of RewriteRuleBuilder.
"
Class {
	#name : #SourcePanelPresenter,
	#superclass : #AbstractPanelPresenter,
	#category : #'RewriteRuleBuilder-Panels'
}

{ #category : #actions }
SourcePanelPresenter >> change [

	| newSource oldNode oldAst |
	oldAst := codePresenter ast copy.
	oldNode := codePresenter getSelectedNode.
	newSource := UIManager default
		             request: 'Enter new source instead of: '
			             , codePresenter getSelectedNode formattedCode
		             initialAnswer: ''.
	(newSource = '' or: [ newSource isNil ])
		ifTrue: [ self changeInvalidAlert ]
		ifFalse: [ 
			codePresenter ast allChildren do: [ :each | 
				each = oldNode ifTrue: [ 
					each command:
						(RenameCommand receiver: each panel: self withSource: newSource).
					each command execute ] ] ].
	self owner transformationRule undoDict add:
		(RewriteRuleChangesKeeper new
			 panel: self asOrderedCollection;
			 ast: oldAst asOrderedCollection;
			 yourself).
	self owner transformationRule undoButton enable.
	self updateTextAndAst.
	self owner matchSourcePanelCode
]

{ #category : #initialization }
SourcePanelPresenter >> initializeLabel [

	label label: 'Source code'
]

{ #category : #initialization }
SourcePanelPresenter >> menuActions [

	| options |
	options := OrderedCollection new.
	codePresenter getSelectedNode isInTemporariesList ifFalse: [ 
		options add: #( 'Change' #change ) ].
	^ options
]
