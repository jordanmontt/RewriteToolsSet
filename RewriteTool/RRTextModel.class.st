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
	#name : #RRTextModel,
	#superclass : #SpCodePresenter,
	#instVars : [
		'model',
		'menuOptions',
		'ast',
		'currentSelection'
	],
	#category : #'RewriteTool-Models'
}

{ #category : #accessing }
RRTextModel >> actionsForSelection [
	^ model perform: menuOptions
]

{ #category : #accessing }
RRTextModel >> ast [
	^ ast
]

{ #category : #accessing }
RRTextModel >> ast: anAST [
	ast := anAST
]

{ #category : #protocol }
RRTextModel >> codePaneMenu: aMenu shifted: shifted [
	| actions |
	self owner updateSelection.
	actions := self actionsForSelection.
	actions do: [ :menuItem | aMenu add: menuItem first target: self targetForMenu selector: menuItem second ].
	^ aMenu
]

{ #category : #accessing }
RRTextModel >> getSelectedNode [
	^ self ast
		bestNodeFor: (self selectionInterval first + 1 to: self selectionInterval last - 1)
]

{ #category : #accessing }
RRTextModel >> menuOptions: aSelector [
	menuOptions := aSelector
]

{ #category : #accessing }
RRTextModel >> model [
	^ model
]

{ #category : #accessing }
RRTextModel >> model: anObject [
	model := anObject
]

{ #category : #accessing }
RRTextModel >> targetForMenu [
	^ model ifNil: [ self ] ifNotNil: [ model ]
]
