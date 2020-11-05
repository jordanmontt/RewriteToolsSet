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
	self owner transformationRule addToUndoList:
		(RewriteRuleChangesKeeper new
			 panel: self asOrderedCollection;
			 ast: oldAst asOrderedCollection;
			 yourself).
	self updateTextAndAst.
	self owner refreshStatusBar
]

{ #category : #initialization }
SourcePanelPresenter >> initializeLabel [

	label label: 'Source code'
]

{ #category : #initialization }
SourcePanelPresenter >> menuActions [

	codePresenter getSelectedNode ifNil: [ ^ {  } ].
	codePresenter getSelectedNode isInTemporariesList ifTrue: [ ^ {  } ].
	^ { #( 'Change' #change ) }
]
