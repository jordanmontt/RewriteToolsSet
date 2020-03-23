"
An AbstractPanel is an abstract class. Its subclasses are one of four panels of RewriteRuleBuilder tool.
It is responsible for implementation of all actions that can be applied to ast nodes in RewriteRuleBuilder tool.
Also it updates self ast ant text, that is displayed.

Instance Variables
	contentText:		<LabeledTextModel>
	varNames:		<OrderedCollection>

contentText
	- an instance of LabeledTextModel

varNames
	- holds names of all metavariables currently existing in MatchPanel

"
Class {
	#name : #AbstractPanel,
	#superclass : #SpPresenter,
	#instVars : [
		'textModel',
		'code',
		'isParsingExpression'
	],
	#category : #'RewriteTool-Panels'
}

{ #category : #specs }
AbstractPanel class >> defaultSpec [
	^ SpBoxLayout newVertical add: #textModel; yourself
]

{ #category : #accessing }
AbstractPanel class >> labelHeight [
	^ 30
]

{ #category : #actions }
AbstractPanel >> abstractBlock [
	self executeCommand: AbstractBlockCommand withSource: ''
]

{ #category : #actions }
AbstractPanel >> abstractCondition [
	self executeCommand: AbstractConditionCommand withSource: ''
]

{ #category : #actions }
AbstractPanel >> abstractLiteral [
	self executeCommand: AbstractLiteralCommand withSource: ''
]

{ #category : #actions }
AbstractPanel >> abstractMessage [
	self executeCommand: AbstractMessageCommand withSource: ''
]

{ #category : #actions }
AbstractPanel >> abstractStatement [
	self executeCommand: AbstractStatementCommand withSource: ''
]

{ #category : #actions }
AbstractPanel >> abstractStatements [
	self executeCommand: AbstractStatementsCommand withSource: ''
]

{ #category : #actions }
AbstractPanel >> abstractTemporariesList [
	self executeCommand: AbstractTemporariesListCommand withSource: ''
]

{ #category : #actions }
AbstractPanel >> abstractVariable [
	self executeCommand: AbstractVariableCommand withSource: ''
]

{ #category : #updating }
AbstractPanel >> addChanges [
	^ nil
]

{ #category : #updating }
AbstractPanel >> addOldNodes: oldAst [
	^ nil
]

{ #category : #actions }
AbstractPanel >> asList [
	self executeCommand: AsListCommand withSource: ''
]

{ #category : #accessing }
AbstractPanel >> blockIndex [
	^ nil
]

{ #category : #actions }
AbstractPanel >> change [
	| newSource |
	newSource := UIManager default
		request: 'Enter new source instead of: ' , self textModel getSelectedNode formattedCode
		initialAnswer: ''.
	(newSource = '' or: [ newSource isNil ])
		ifTrue: [ self changeInvalidAlert ]
		ifFalse: [ self executeCommand: RenameCommand withSource: newSource ]
]

{ #category : #actions }
AbstractPanel >> change: newSource [
	self executeCommand: RenameCommand withSource: newSource
]

{ #category : #alerts }
AbstractPanel >> changeInvalidAlert [
	UIManager default alert: 'Please input valid data.' title: 'Invalid input !'
]

{ #category : #updating }
AbstractPanel >> chooseMetavariablesForNode: aNode [
	^ nil
]

{ #category : #updating }
AbstractPanel >> chooseTempsForNode: aNode [
	^ nil
]

{ #category : #alerts }
AbstractPanel >> classNotCreatedAlert [
	UIManager default alert: 'Class not created.' title: 'Alert'
]

{ #category : #accessing }
AbstractPanel >> code [
	^ code ifNil: [ code := (self parse: '| temp | self isNil ifTrue: [ ^ true ]. temp size') formattedCode ]
]

{ #category : #accessing }
AbstractPanel >> code: aString [
	code := aString.
	self textModel text: aString.
	self textModel ast: (self parse: aString)
]

{ #category : #accessing }
AbstractPanel >> conditionIndex [
	^ nil
]

{ #category : #enumerating }
AbstractPanel >> difference: aCollection with: anotherCollection [
	anotherCollection do: [ :each | aCollection remove: each ifAbsent: [ nil ] ].
	^ aCollection
]

{ #category : #execute }
AbstractPanel >> executeCommand: aCommandClass withSource: aString [
	| node oldAst newNode tempNode |
	oldAst := self textModel ast copy.
	node := self textModel getSelectedNode.
	((self isReplacementPossibleFor: node) or: [ aCommandClass isTemps ])
		ifTrue: [ 
			self textModel ast allChildren
				do: [ :each | 
					(each = node and: [ aCommandClass isAccepted: each ])
						ifTrue: [ 
							tempNode := aCommandClass isSequenceNeeded
								ifTrue: [ each getSequenceParent ]
								ifFalse: [ each ].
							tempNode command: (aCommandClass receiver: tempNode panel: self withSource: aString).
							newNode := tempNode command execute ] ].
			self manageUndoDictFor: oldAst.
			self updateInfoFor: oldAst withOld: tempNode copy andNew: newNode ]
		ifFalse: [ self replacementNotPossibleAlert ]
]

{ #category : #accessing }
AbstractPanel >> getAllMetavariables [
	^ self textModel ast allChildren select: [ :each | each isPatternNode ]
]

{ #category : #accessing }
AbstractPanel >> getSelectedMetavarsFor: aNode [
	^ aNode allChildren select: [ :each | each isPatternNode and: [ each ~= aNode ] ]
]

{ #category : #initialization }
AbstractPanel >> initializePresenters [
	self instantiateThePresenters.
	self textModel
		dragEnabled;
		text: self code;
		ast: (self parse: self code);
		syntaxHighlight: true;
		model: self;
		menuOptions: #menuActions
]

{ #category : #initialization }
AbstractPanel >> instantiateThePresenters [
	textModel := self instantiate: RRTextModel
]

{ #category : #testing }
AbstractPanel >> isReplacementPossibleFor: aNode [
	| selectedMetavars allMetavars usedMetavars |
	selectedMetavars := self getSelectedMetavarsFor: aNode.
	allMetavars := self getAllMetavariables.
	usedMetavars := self owner transformPanel getAllMetavariables.
	^ (((self difference: allMetavars copy with: selectedMetavars) & selectedMetavars) == selectedMetavars
		and: [ 
			((selectedMetavars & usedMetavars) isNotEmpty or: [ (selectedMetavars | usedMetavars) isEmpty ])
				or: [ selectedMetavars isEmpty ] ])
		or: [ self owner transformPanel textModel ast allChildren anySatisfy: [ :each | each = aNode ] ]
]

{ #category : #testing }
AbstractPanel >> isSelectedAll [
	^ self textModel getSelectedNode formattedCode size = self textModel ast formattedCode size
]

{ #category : #accessing }
AbstractPanel >> literalIndex [
	^ nil
]

{ #category : #updating }
AbstractPanel >> manageUndoDictFor: oldAst [
	self owner undoDict
		add:
			(RewriteRuleChange new
				panel: self asOrderedCollection;
				ast: oldAst asOrderedCollection;
				yourself).
	self addChanges.
	self owner undoButton enable
]

{ #category : #initialization }
AbstractPanel >> menuActions [
	| options |
	options := OrderedCollection new.
	options addAll: self textModel getSelectedNode optionsForNode.
	^ options
]

{ #category : #alerts }
AbstractPanel >> noMetavariablesAlert [
	UIManager default alert: 'No available metavariables for selected node.' title: 'Alert'
]

{ #category : #parsing }
AbstractPanel >> parse: aString [
	^ RBParser parseRewriteExpression: aString
]

{ #category : #actions }
AbstractPanel >> recurseInto [
	self executeCommand: RecurseIntoCommand withSource: ''
]

{ #category : #alerts }
AbstractPanel >> replacementNotPossibleAlert [
	UIManager default
		alert: 'Can not replace this node, because it declars a metavariable which also is in rhs expression.'
		title: 'Alert'
]

{ #category : #accessing }
AbstractPanel >> statementIndex [
	^ nil
]

{ #category : #accessing }
AbstractPanel >> textModel [
	^ textModel
]

{ #category : #accessing }
AbstractPanel >> tool [
	^ self owner owner
]

{ #category : #actions }
AbstractPanel >> undoOnNode [
	self executeCommand: UndoOnNodeCommand withSource: ''
]

{ #category : #updating }
AbstractPanel >> updateAst [
	self textModel ast: (self parse: self textModel text)
]

{ #category : #updating }
AbstractPanel >> updateInfoFor: oldAst withOld: oldNode andNew: newNode [
	| myNewNode |
	self updateTextAndAst.
	myNewNode := newNode ifNil: [ self textModel getSelectedNode ].
	self textModel ast
		nodesDo: [ :each | 
			each = myNewNode
				ifTrue: [ 
					each oldNodes add: oldNode.
					self updateNextPanelForNode: each ] ].
	self addOldNodes: oldAst
]

{ #category : #updating }
AbstractPanel >> updateNextPanelForNode: aNode [
]

{ #category : #updating }
AbstractPanel >> updateSelection [
	^ nil
]

{ #category : #updating }
AbstractPanel >> updateText [
	self textModel text: self textModel ast formattedCode
]

{ #category : #updating }
AbstractPanel >> updateTextAndAst [
	self
		updateText;
		updateAst;
		yourself
]

{ #category : #accessing }
AbstractPanel >> varIndex [
	^ nil
]

{ #category : #alerts }
AbstractPanel >> varNotChosenAlert [
	UIManager default alert: 'Variable not chosen or does not exist.' title: 'Alert'
]
