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
	#name : #MatchPanel,
	#superclass : #AbstractPanel,
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
MatchPanel >> abstractBlock [
	super abstractBlock.
	self blockIndex: self blockIndex + 1
]

{ #category : #actions }
MatchPanel >> abstractCondition [
	super abstractCondition.
	self conditionIndex: self conditionIndex + 1
]

{ #category : #actions }
MatchPanel >> abstractLiteral [
	super abstractLiteral.
	self literalIndex: self literalIndex + 1
]

{ #category : #actions }
MatchPanel >> abstractMessage [
	super abstractMessage.
	self varIndex: self varIndex + 1
]

{ #category : #actions }
MatchPanel >> abstractStatement [
	super abstractStatement.
	self statementIndex: self statementIndex + 1
]

{ #category : #actions }
MatchPanel >> abstractTemporariesList [
	super abstractTemporariesList.
	self tempListIndex: self tempListIndex + 1
]

{ #category : #actions }
MatchPanel >> abstractVariable [
	super abstractVariable.
	self varIndex: self varIndex + 1
]

{ #category : #updating }
MatchPanel >> addChanges [
	self owner undoDict last panel add: self owner transformPanel.
	self owner undoDict last ast add: self owner transformPanel textModel ast copy

]

{ #category : #accessing }
MatchPanel >> blockIndex [
	^ blockIndex
]

{ #category : #accessing }
MatchPanel >> blockIndex: anObject [
	blockIndex := anObject
]

{ #category : #accessing }
MatchPanel >> conditionIndex [
	^ conditionIndex
]

{ #category : #accessing }
MatchPanel >> conditionIndex: anObject [
	conditionIndex := anObject
]

{ #category : #accessing }
MatchPanel >> getTemporaries [
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
MatchPanel >> initialize [
	super initialize.
	varIndex := 1.
	blockIndex := 1.
	literalIndex := 1.
	statementIndex := 1.
	conditionIndex := 1.
	tempListIndex := 1
]

{ #category : #initialization }
MatchPanel >> initializePresenters [
	super initializePresenters.
	self textModel syntaxHighlight: false.
	self varNames: OrderedCollection new
]

{ #category : #accessing }
MatchPanel >> literalIndex [
	^ literalIndex
]

{ #category : #accessing }
MatchPanel >> literalIndex: anObject [
	literalIndex := anObject
]

{ #category : #accessing }
MatchPanel >> statementIndex [
	^ statementIndex
]

{ #category : #accessing }
MatchPanel >> statementIndex: anObject [
	statementIndex := anObject
]

{ #category : #accessing }
MatchPanel >> tempListIndex [
	^ tempListIndex
]

{ #category : #accessing }
MatchPanel >> tempListIndex: anObject [
	tempListIndex := anObject
]

{ #category : #actions }
MatchPanel >> undoOnNode [
	| node |
	node := self textModel getSelectedNode.
	super undoOnNode.
	self updateNextPanelForNode: node
]

{ #category : #updating }
MatchPanel >> updateNextPanelForNode: aNode [
	self updateVarNames.
	aNode
		ifNotNil: [ aNode oldNodes ifNotEmpty: [ self updateTransformPanelFor: aNode ] ].
	self tool statusBar color: self tool matchColor.
	self tool statusBar adapter infoText: self tool matchLabel.
	self owner transformPanel updateNextPanelForNode: aNode
]

{ #category : #updating }
MatchPanel >> updateSelection [
	| selectedNode |
	selectedNode := self textModel getSelectedNode.
	self owner transformPanel textModel ast allChildren
		do: [ :each | 
			each = selectedNode
				ifTrue: [ self textModel widget widget setSelection: selectedNode sourceInterval.
					self owner transformPanel textModel widget widget setSelection: each sourceInterval ] ]
]

{ #category : #updating }
MatchPanel >> updateTransformPanelFor: aNode [
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
MatchPanel >> updateVarNames [
	self varNames: self getAllMetavariables asSet asOrderedCollection
]

{ #category : #accessing }
MatchPanel >> varIndex [
	^ varIndex
]

{ #category : #accessing }
MatchPanel >> varIndex: anObject [
	varIndex := anObject
]

{ #category : #accessing }
MatchPanel >> varNames [
	^ varNames
]

{ #category : #accessing }
MatchPanel >> varNames: anObject [
	varNames := anObject
]
