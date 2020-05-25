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
	#name : #SearchForCodePresenter,
	#superclass : #AbstractRuleCodePresenter,
	#instVars : [
		'blockIndex',
		'conditionIndex',
		'literalIndex',
		'statementIndex',
		'varIndex',
		'tempListIndex',
		'varNames'
	],
	#category : #'RewriteTool-SharedPresenters'
}

{ #category : #actions }
SearchForCodePresenter >> abstractBlock [
	super abstractBlock.
	blockIndex := blockIndex + 1
]

{ #category : #actions }
SearchForCodePresenter >> abstractCondition [
	super abstractCondition.
	conditionIndex := conditionIndex + 1
]

{ #category : #actions }
SearchForCodePresenter >> abstractLiteral [
	super abstractLiteral.
	literalIndex := literalIndex + 1
]

{ #category : #actions }
SearchForCodePresenter >> abstractMessage [
	super abstractMessage.
	varIndex := varIndex + 1
]

{ #category : #actions }
SearchForCodePresenter >> abstractStatement [
	super abstractStatement.
	statementIndex := statementIndex + 1
]

{ #category : #actions }
SearchForCodePresenter >> abstractTemporariesList [
	super abstractTemporariesList.
	tempListIndex := tempListIndex + 1
]

{ #category : #actions }
SearchForCodePresenter >> abstractVariable [
	super abstractVariable.
	varIndex := varIndex + 1
]

{ #category : #updating }
SearchForCodePresenter >> addChanges [
	self flag: #accesOwner.
	self owner undoDict last panel add: self owner replaceWithPanel.
	self owner undoDict last ast
		add: self owner replaceWithPanel textModel ast copy
]

{ #category : #accessing }
SearchForCodePresenter >> blockIndex [
	^ blockIndex
]

{ #category : #accessing }
SearchForCodePresenter >> conditionIndex [
	^ conditionIndex
]

{ #category : #accessing }
SearchForCodePresenter >> getTemporaries [
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
SearchForCodePresenter >> initialize [
	super initialize.
	varIndex := 1.
	blockIndex := 1.
	literalIndex := 1.
	statementIndex := 1.
	conditionIndex := 1.
	tempListIndex := 1.
	
]

{ #category : #initialization }
SearchForCodePresenter >> initializePresenters [
	super initializePresenters.
	codePresenter syntaxHighlight: false.
	varNames := OrderedCollection new.
	label label: 'Search for:'
]

{ #category : #accessing }
SearchForCodePresenter >> literalIndex [
	^ literalIndex
]

{ #category : #accessing }
SearchForCodePresenter >> statementIndex [
	^ statementIndex
]

{ #category : #accessing }
SearchForCodePresenter >> tempListIndex [
	^ tempListIndex
]

{ #category : #actions }
SearchForCodePresenter >> undoOnNode [
	| node |
	node := self textModel getSelectedNode.
	super undoOnNode.
	self updateNextPanelForNode: node
]

{ #category : #updating }
SearchForCodePresenter >> updateNextPanelForNode: aNode [
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
SearchForCodePresenter >> updateSelection [
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
SearchForCodePresenter >> updateTransformPanelFor: aNode [
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
SearchForCodePresenter >> updateVarNames [
	varNames := self getAllMetavariables asSet asOrderedCollection
]

{ #category : #accessing }
SearchForCodePresenter >> varIndex [
	^ varIndex
]

{ #category : #accessing }
SearchForCodePresenter >> varNames [
	^ varNames
]
