"
A MatchPanel is a subclass of AbstractPanel.
Holds matching part of rewrite rule.
Located in bottom left part of RewriteRuleBuilder.

Instance Variables
	blockIndex:		<Integer>
	conditionIndex:		<Integer>
	literalIndex:		<Integer>
	statementIndex:		<Integer>
	varIndex:		<Integer>

blockIndex
	- index (count) of block metavariables

conditionIndex
	- index (count) of condition metavariables

literalIndex
	- index (count) of literal metavariables

statementIndex
	- index (count) of statement metavariables
	
varIndex
	- index (count) of variable metavariables

"
Class {
	#name : #SearchForPanelPresenter,
	#superclass : #AbstractPanelPresenter,
	#instVars : [
		'blockIndex',
		'conditionIndex',
		'literalIndex',
		'statementIndex',
		'varIndex',
		'tempListIndex',
		'varNames'
	],
	#category : #'RewriteTool-CommonPresenters'
}

{ #category : #actions }
SearchForPanelPresenter >> abstractBlock [
	super abstractBlock.
	self blockIndex: self blockIndex + 1
]

{ #category : #actions }
SearchForPanelPresenter >> abstractCondition [
	super abstractCondition.
	self conditionIndex: self conditionIndex + 1
]

{ #category : #actions }
SearchForPanelPresenter >> abstractLiteral [
	super abstractLiteral.
	self literalIndex: self literalIndex + 1
]

{ #category : #actions }
SearchForPanelPresenter >> abstractMessage [
	super abstractMessage.
	self varIndex: self varIndex + 1
]

{ #category : #actions }
SearchForPanelPresenter >> abstractStatement [
	super abstractStatement.
	self statementIndex: self statementIndex + 1
]

{ #category : #actions }
SearchForPanelPresenter >> abstractTemporariesList [
	super abstractTemporariesList.
	self tempListIndex: self tempListIndex + 1
]

{ #category : #actions }
SearchForPanelPresenter >> abstractVariable [
	super abstractVariable.
	self varIndex: self varIndex + 1
]

{ #category : #updating }
SearchForPanelPresenter >> addChanges [
	self flag: #accesOwner.
	self owner undoDict last panel add: self owner replaceWithPanel.
	self owner undoDict last ast
		add: self owner replaceWithPanel textModel ast copy
]

{ #category : #accessing }
SearchForPanelPresenter >> blockIndex [
	^ blockIndex
]

{ #category : #accessing }
SearchForPanelPresenter >> blockIndex: anObject [
	blockIndex := anObject
]

{ #category : #accessing }
SearchForPanelPresenter >> conditionIndex [
	^ conditionIndex
]

{ #category : #accessing }
SearchForPanelPresenter >> conditionIndex: anObject [
	conditionIndex := anObject
]

{ #category : #accessing }
SearchForPanelPresenter >> getTemporaries [
	| temps |
	temps := OrderedCollection new.
	self textModel ast
		nodesDo: [ :each | 
			each isSequence
				ifTrue: [ temps addAll: each temporaries ] ].
	temps removeDuplicates.
	temps removeAllSuchThat: [ :each | each isPatternNode not ].
	^ temps
]

{ #category : #initialization }
SearchForPanelPresenter >> initialize [
	super initialize.
	varIndex := 1.
	blockIndex := 1.
	literalIndex := 1.
	statementIndex := 1.
	conditionIndex := 1.
	tempListIndex := 1.
	
]

{ #category : #initialization }
SearchForPanelPresenter >> initializePresenters [
	super initializePresenters.
	self textModel syntaxHighlight: false.
	self varNames: OrderedCollection new
]

{ #category : #accessing }
SearchForPanelPresenter >> literalIndex [
	^ literalIndex
]

{ #category : #accessing }
SearchForPanelPresenter >> literalIndex: anObject [
	literalIndex := anObject
]

{ #category : #accessing }
SearchForPanelPresenter >> statementIndex [
	^ statementIndex
]

{ #category : #accessing }
SearchForPanelPresenter >> statementIndex: anObject [
	statementIndex := anObject
]

{ #category : #accessing }
SearchForPanelPresenter >> tempListIndex [
	^ tempListIndex
]

{ #category : #accessing }
SearchForPanelPresenter >> tempListIndex: anObject [
	tempListIndex := anObject
]

{ #category : #actions }
SearchForPanelPresenter >> undoOnNode [
	| node |
	node := self textModel getSelectedNode.
	super undoOnNode.
	self updateNextPanelForNode: node
]

{ #category : #updating }
SearchForPanelPresenter >> updateNextPanelForNode: aNode [
	self updateVarNames.
	aNode
		ifNotNil: [ aNode oldNodes ifNotEmpty: [ self updateTransformPanelFor: aNode ] ].
		self flag: #accessOwner.
		"Tool is same as owner"
	self tool statusBar color: self tool matchColor.
	self tool statusBar morph infoText: self tool matchLabel.
	self flag: #accessOwner.
	self owner replaceWithPanel updateNextPanelForNode: aNode
]

{ #category : #updating }
SearchForPanelPresenter >> updateSelection [
	| selectedNode |
	selectedNode := self textModel getSelectedNode.
	self owner replaceWithPanel textModel ast allChildren
		do: [ :each | 
			each = selectedNode
				ifTrue: [ self textModel adapter widget
						setSelection: selectedNode sourceInterval.
					self owner replaceWithPanel textModel adapter widget
						setSelection: each sourceInterval ] ]
]

{ #category : #updating }
SearchForPanelPresenter >> updateTransformPanelFor: aNode [
	self flag: #accessOwner.
	self owner replaceWithPanel textModel ast allChildren
		do: [ :each | 
			(each = aNode oldNodes last
				and: [ aNode oldNodes last command class isAccepted: each ])
				ifTrue: [ self textModel selectionInterval: aNode sourceInterval.
					self isSelectedAll
						ifTrue: [ self owner replaceWithPanel textModel ast: aNode copy ]
						ifFalse: [ each replaceWith: aNode copy ] ] ].
	self owner replaceWithPanel updateTextAndAst
]

{ #category : #updating }
SearchForPanelPresenter >> updateVarNames [
	self varNames: self getAllMetavariables asSet asOrderedCollection
]

{ #category : #accessing }
SearchForPanelPresenter >> varIndex [
	^ varIndex
]

{ #category : #accessing }
SearchForPanelPresenter >> varIndex: anObject [
	varIndex := anObject
]

{ #category : #accessing }
SearchForPanelPresenter >> varNames [
	^ varNames
]

{ #category : #accessing }
SearchForPanelPresenter >> varNames: anObject [
	varNames := anObject
]
