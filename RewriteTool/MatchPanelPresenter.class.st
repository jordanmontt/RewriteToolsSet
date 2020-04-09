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
	#name : #MatchPanelPresenter,
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
	#category : #'RewriteTool-Panels'
}

{ #category : #actions }
MatchPanelPresenter >> abstractBlock [
	super abstractBlock.
	self blockIndex: self blockIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractCondition [
	super abstractCondition.
	self conditionIndex: self conditionIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractLiteral [
	super abstractLiteral.
	self literalIndex: self literalIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractMessage [
	super abstractMessage.
	self varIndex: self varIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractStatement [
	super abstractStatement.
	self statementIndex: self statementIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractTemporariesList [
	super abstractTemporariesList.
	self tempListIndex: self tempListIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractVariable [
	super abstractVariable.
	self varIndex: self varIndex + 1
]

{ #category : #updating }
MatchPanelPresenter >> addChanges [
	self owner undoDict last panel add: self owner transformPanel.
	self owner undoDict last ast add: self owner transformPanel textModel ast copy

]

{ #category : #accessing }
MatchPanelPresenter >> blockIndex [
	^ blockIndex
]

{ #category : #accessing }
MatchPanelPresenter >> blockIndex: anObject [
	blockIndex := anObject
]

{ #category : #accessing }
MatchPanelPresenter >> conditionIndex [
	^ conditionIndex
]

{ #category : #accessing }
MatchPanelPresenter >> conditionIndex: anObject [
	conditionIndex := anObject
]

{ #category : #accessing }
MatchPanelPresenter >> getTemporaries [
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
MatchPanelPresenter >> initialize [
	super initialize.
	varIndex := 1.
	blockIndex := 1.
	literalIndex := 1.
	statementIndex := 1.
	conditionIndex := 1.
	tempListIndex := 1.
	
]

{ #category : #initialization }
MatchPanelPresenter >> initializePresenters [
	super initializePresenters.
	self textModel syntaxHighlight: false.
	self varNames: OrderedCollection new
]

{ #category : #accessing }
MatchPanelPresenter >> literalIndex [
	^ literalIndex
]

{ #category : #accessing }
MatchPanelPresenter >> literalIndex: anObject [
	literalIndex := anObject
]

{ #category : #accessing }
MatchPanelPresenter >> statementIndex [
	^ statementIndex
]

{ #category : #accessing }
MatchPanelPresenter >> statementIndex: anObject [
	statementIndex := anObject
]

{ #category : #accessing }
MatchPanelPresenter >> tempListIndex [
	^ tempListIndex
]

{ #category : #accessing }
MatchPanelPresenter >> tempListIndex: anObject [
	tempListIndex := anObject
]

{ #category : #actions }
MatchPanelPresenter >> undoOnNode [
	| node |
	node := self textModel getSelectedNode.
	super undoOnNode.
	self updateNextPanelForNode: node
]

{ #category : #updating }
MatchPanelPresenter >> updateNextPanelForNode: aNode [
	self updateVarNames.
	aNode
		ifNotNil: [ aNode oldNodes ifNotEmpty: [ self updateTransformPanelFor: aNode ] ].
	self tool statusBar color: self tool matchColor.	
	self tool statusBar morph infoText: self tool matchLabel.
	self owner transformPanel updateNextPanelForNode: aNode
]

{ #category : #updating }
MatchPanelPresenter >> updateSelection [
	| selectedNode |
	selectedNode := self textModel getSelectedNode.
	self owner transformPanel textModel ast allChildren
		do: [ :each | 
			each = selectedNode
				ifTrue: [ self textModel adapter widget
						setSelection: selectedNode sourceInterval.
					self owner transformPanel textModel adapter widget
						setSelection: each sourceInterval ] ]
]

{ #category : #updating }
MatchPanelPresenter >> updateTransformPanelFor: aNode [
	self owner transformPanel textModel ast allChildren
		do: [ :each | 
			(each = aNode oldNodes last
				and: [ aNode oldNodes last command class isAccepted: each ])
				ifTrue: [ self textModel selectionInterval: aNode sourceInterval.
					self isSelectedAll
						ifTrue: [ self owner transformPanel textModel ast: aNode copy ]
						ifFalse: [ each replaceWith: aNode copy ] ] ].
	self owner transformPanel updateTextAndAst
]

{ #category : #updating }
MatchPanelPresenter >> updateVarNames [
	self varNames: self getAllMetavariables asSet asOrderedCollection
]

{ #category : #accessing }
MatchPanelPresenter >> varIndex [
	^ varIndex
]

{ #category : #accessing }
MatchPanelPresenter >> varIndex: anObject [
	varIndex := anObject
]

{ #category : #accessing }
MatchPanelPresenter >> varNames [
	^ varNames
]

{ #category : #accessing }
MatchPanelPresenter >> varNames: anObject [
	varNames := anObject
]
