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
	#category : #'RewriteRuleBuilder-Panels'
}

{ #category : #actions }
MatchPanelPresenter >> abstractBlock [

	super abstractBlock.
	blockIndex := blockIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractCondition [

	super abstractCondition.
	conditionIndex := conditionIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractLiteral [

	super abstractLiteral.
	literalIndex := literalIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractMessage [

	super abstractMessage.
	varIndex := varIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractStatement [

	super abstractStatement.
	statementIndex := statementIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractTemporariesList [

	super abstractTemporariesList.
	tempListIndex := tempListIndex + 1
]

{ #category : #actions }
MatchPanelPresenter >> abstractVariable [

	super abstractVariable.
	varIndex := varIndex + 1
]

{ #category : #updating }
MatchPanelPresenter >> addChanges [

	self owner addPanelToLastOfUndoDict: self owner transformPanel.
	self owner addAstToLastOfUndoDict: self owner transformPanel ast copy
]

{ #category : #accessing }
MatchPanelPresenter >> blockIndex [
	^ blockIndex
]

{ #category : #accessing }
MatchPanelPresenter >> conditionIndex [
	^ conditionIndex
]

{ #category : #accessing }
MatchPanelPresenter >> getTemporaries [

	| temps |
	temps := OrderedCollection new.
	codePresenter ast nodesDo: [ :each | 
		each isSequence ifTrue: [ temps addAll: each temporaries ] ].
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
	tempListIndex := 1
]

{ #category : #initialization }
MatchPanelPresenter >> initializeLabel [

	label label: 'Search for:'
]

{ #category : #initialization }
MatchPanelPresenter >> initializePresenters [

	super initializePresenters.
	codePresenter syntaxHighlight: false.
	varNames := OrderedCollection new
]

{ #category : #accessing }
MatchPanelPresenter >> literalIndex [
	^ literalIndex
]

{ #category : #accessing }
MatchPanelPresenter >> statementIndex [

	^ statementIndex
]

{ #category : #accessing }
MatchPanelPresenter >> tempListIndex [
	^ tempListIndex
]

{ #category : #actions }
MatchPanelPresenter >> undoOnNode [

	| node |
	node := codePresenter getSelectedNode.
	super undoOnNode.
	self updateNextPanelForNode: node
]

{ #category : #updating }
MatchPanelPresenter >> updateNextPanelForNode: aNode [

	self updateVarNames.
	aNode ifNotNil: [ 
		aNode oldNodes ifNotEmpty: [ self updateTransformPanelFor: aNode ] ].
	self tool refreshStatusBar.
	self tool updateResultPanelAst
]

{ #category : #updating }
MatchPanelPresenter >> updateSelection [

	| selectedNode |
	selectedNode := codePresenter getSelectedNode.
	self owner transformPanel ast allChildren do: [ :each | 
		each = selectedNode ifTrue: [ 
			codePresenter selectionInterval: selectedNode sourceInterval.
			self owner transformPanel codePresenter selectionInterval:
				each sourceInterval ] ]
]

{ #category : #updating }
MatchPanelPresenter >> updateTransformPanelFor: aNode [

	self owner transformPanel ast allChildren do: [ :each | 
		(each = aNode oldNodes last and: [ 
			 aNode oldNodes last command class isAccepted: each ]) ifTrue: [ 
			codePresenter selectionInterval: aNode sourceInterval.
			self isSelectedAll
				ifTrue: [ self owner transformPanel ast: aNode copy ]
				ifFalse: [ "aqui " each replaceWith: aNode copy ] ] ].
	self owner transformPanel updateTextAndAst
]

{ #category : #updating }
MatchPanelPresenter >> updateVarNames [

	varNames := self getAllMetavariables asSet asOrderedCollection
]

{ #category : #accessing }
MatchPanelPresenter >> varIndex [
	^ varIndex
]

{ #category : #accessing }
MatchPanelPresenter >> varNames [
	^ varNames
]
