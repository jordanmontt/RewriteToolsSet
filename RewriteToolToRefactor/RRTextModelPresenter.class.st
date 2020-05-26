"
A RRTextModel is a subclass of TextModel. Has some features that are needed for RewriteRuleBuilder, like AST and new menu.

Instance Variables
	ast:		<RBProgramNode>
	menuOptionsSelector:		<Object>
	model:		<Object>

ast
	- an AST of current source code

menuOptionsSelector
	- responsible for menu

model
	- model

"
Class {
	#name : #RRTextModelPresenter,
	#superclass : #SpCodePresenter,
	#instVars : [
		'model',
		'menuOptions',
		'ast',
		'currentSelection'
	],
	#category : #'RewriteToolToRefactor-Models'
}

{ #category : #accessing }
RRTextModelPresenter >> actionsForSelection [
	^ model perform: menuOptions
]

{ #category : #accessing }
RRTextModelPresenter >> ast [
	^ ast
]

{ #category : #accessing }
RRTextModelPresenter >> ast: anAST [
	ast := anAST
]

{ #category : #protocol }
RRTextModelPresenter >> buildMenu [
	| actions aMenu |
	aMenu := MenuMorph new.
	self owner updateSelection.
	actions := self actionsForSelection.
	actions
		do: [ :menuItem | 
			aMenu
				add: menuItem first
				target: self targetForMenu
				selector: menuItem second ].
	^ aMenu
]

{ #category : #protocol }
RRTextModelPresenter >> codePaneMenu: aMenu shifted: shifted [
	| actions |
	self owner updateSelection.
	actions := self actionsForSelection.
	actions do: [ :menuItem | aMenu add: menuItem first target: self targetForMenu selector: menuItem second ].
	^ aMenu
]

{ #category : #accessing }
RRTextModelPresenter >> getSelectedNode [
	^ self ast
		bestNodeFor: (self selectionInterval first + 1 to: self selectionInterval last - 1)
]

{ #category : #initialization }
RRTextModelPresenter >> initialize [
	super initialize.
	self contextMenu: [ self buildMenu ].
]

{ #category : #accessing }
RRTextModelPresenter >> menuOptions: aSelector [
	menuOptions := aSelector
]

{ #category : #accessing }
RRTextModelPresenter >> model [
	^ model
]

{ #category : #accessing }
RRTextModelPresenter >> model: anObject [
	self flag: 'this should be eliminated'.
	model := anObject
]

{ #category : #accessing }
RRTextModelPresenter >> targetForMenu [
	^ model ifNil: [ self ] ifNotNil: [ model ]
]
