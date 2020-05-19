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
	#name : #AbstractPanelPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'textModel',
		'code'
	],
	#category : #'RewriteTool-Presenters'
}

{ #category : #specs }
AbstractPanelPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical add: #textModel; yourself
]

{ #category : #accessing }
AbstractPanelPresenter class >> labelHeight [
	^ 30
]

{ #category : #actions }
AbstractPanelPresenter >> abstractBlock [
	self executeCommand: AbstractBlockCommand withSource: ''
]

{ #category : #actions }
AbstractPanelPresenter >> abstractCondition [
	self executeCommand: AbstractConditionCommand withSource: ''
]

{ #category : #actions }
AbstractPanelPresenter >> abstractLiteral [
	self executeCommand: AbstractLiteralCommand withSource: ''
]

{ #category : #actions }
AbstractPanelPresenter >> abstractMessage [
	self executeCommand: AbstractMessageCommand withSource: ''
]

{ #category : #actions }
AbstractPanelPresenter >> abstractStatement [
	self executeCommand: AbstractStatementCommand withSource: ''
]

{ #category : #actions }
AbstractPanelPresenter >> abstractStatements [
	self executeCommand: AbstractStatementsCommand withSource: ''
]

{ #category : #actions }
AbstractPanelPresenter >> abstractTemporariesList [
	self executeCommand: AbstractTemporariesListCommand withSource: ''
]

{ #category : #actions }
AbstractPanelPresenter >> abstractVariable [
	self executeCommand: AbstractVariableCommand withSource: ''
]

{ #category : #updating }
AbstractPanelPresenter >> addChanges [
	^ nil
]

{ #category : #updating }
AbstractPanelPresenter >> addOldNodes: oldAst [
	^ nil
]

{ #category : #actions }
AbstractPanelPresenter >> asList [
	self executeCommand: AsListCommand withSource: ''
]

{ #category : #accessing }
AbstractPanelPresenter >> blockIndex [
	^ nil
]

{ #category : #actions }
AbstractPanelPresenter >> change [
	| newSource |
	newSource := UIManager default
		request:
			'Enter new source instead of: '
				,
					textModel getSelectedNode formattedCode
		initialAnswer: ''.
	(newSource = '' or: [ newSource isNil ])
		ifTrue: [ self changeInvalidAlert ]
		ifFalse: [ self executeCommand: RenameCommand withSource: newSource ]
]

{ #category : #actions }
AbstractPanelPresenter >> change: newSource [
	self executeCommand: RenameCommand withSource: newSource
]

{ #category : #alerts }
AbstractPanelPresenter >> changeInvalidAlert [
	UIManager default alert: 'Please input valid data.' title: 'Invalid input !'
]

{ #category : #updating }
AbstractPanelPresenter >> chooseMetavariablesForNode: aNode [
	^ nil
]

{ #category : #updating }
AbstractPanelPresenter >> chooseTempsForNode: aNode [
	^ nil
]

{ #category : #alerts }
AbstractPanelPresenter >> classNotCreatedAlert [
	UIManager default alert: 'Class not created.' title: 'Alert'
]

{ #category : #accessing }
AbstractPanelPresenter >> code [
	^ code ifNil: [ code := (self parse: '| temp | self isNil ifTrue: [ ^ true ]. temp size') formattedCode ]
]

{ #category : #accessing }
AbstractPanelPresenter >> code: aString [
	code := aString.
	textModel text: aString.
	textModel ast: (self parse: aString)
]

{ #category : #accessing }
AbstractPanelPresenter >> conditionIndex [
	^ nil
]

{ #category : #enumerating }
AbstractPanelPresenter >> difference: aCollection with: anotherCollection [
	anotherCollection do: [ :each | aCollection remove: each ifAbsent: [ nil ] ].
	^ aCollection
]

{ #category : #execute }
AbstractPanelPresenter >> executeCommand: aCommandClass withSource: aString [
	| node oldAst newNode tempNode |
	oldAst := textModel ast copy.
	node := textModel getSelectedNode.
	((self isReplacementPossibleFor: node) or: [ aCommandClass isTemps ])
		ifTrue: [ textModel ast allChildren
				do: [ :each | 
					(each = node and: [ aCommandClass isAccepted: each ])
						ifTrue: [ tempNode := aCommandClass isSequenceNeeded
								ifTrue: [ each getSequenceParent ]
								ifFalse: [ each ].
							tempNode
								command: (aCommandClass receiver: tempNode panel: self withSource: aString).
							newNode := tempNode command execute ] ].
			self manageUndoDictFor: oldAst.
			self updateInfoFor: oldAst withOld: tempNode copy andNew: newNode ]
		ifFalse: [ self replacementNotPossibleAlert ]
]

{ #category : #accessing }
AbstractPanelPresenter >> getAllMetavariables [
	^ textModel ast allChildren select: [ :each | each isPatternNode ]
]

{ #category : #accessing }
AbstractPanelPresenter >> getSelectedMetavarsFor: aNode [
	^ aNode allChildren select: [ :each | each isPatternNode and: [ each ~= aNode ] ]
]

{ #category : #initialization }
AbstractPanelPresenter >> initializePresenters [
	self instantiateThePresenters.
	textModel
		dragEnabled;
		text: self code;
		ast: (self parse: self code);
		syntaxHighlight: true;
		model: self;
		menuOptions: #menuActions
]

{ #category : #initialization }
AbstractPanelPresenter >> instantiateThePresenters [
	textModel := self instantiate: RRTextModelPresenter
]

{ #category : #testing }
AbstractPanelPresenter >> isReplacementPossibleFor: aNode [
	| selectedMetavars allMetavars usedMetavars |
	selectedMetavars := self getSelectedMetavarsFor: aNode.
	allMetavars := self getAllMetavariables.
	self flag: #accessOwner.
	usedMetavars := self owner replaceWithPanel getAllMetavariables.
	^ (((self difference: allMetavars copy with: selectedMetavars)
		& selectedMetavars) == selectedMetavars
		and: [ ((selectedMetavars & usedMetavars) isNotEmpty
				or: [ (selectedMetavars | usedMetavars) isEmpty ])
				or: [ selectedMetavars isEmpty ] ])
		or: [ self owner replaceWithPanel textModel ast allChildren
				anySatisfy: [ :each | each = aNode ] ]
]

{ #category : #testing }
AbstractPanelPresenter >> isSelectedAll [
	^ textModel getSelectedNode formattedCode size = textModel ast formattedCode size
]

{ #category : #accessing }
AbstractPanelPresenter >> literalIndex [
	^ nil
]

{ #category : #updating }
AbstractPanelPresenter >> manageUndoDictFor: oldAst [
	self flag: #accesOwner.
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
AbstractPanelPresenter >> menuActions [
	| options |
	options := OrderedCollection new.
	options addAll: textModel getSelectedNode optionsForNode.
	^ options
]

{ #category : #alerts }
AbstractPanelPresenter >> noMetavariablesAlert [
	UIManager default alert: 'No available metavariables for selected node.' title: 'Alert'
]

{ #category : #parsing }
AbstractPanelPresenter >> parse: aString [
	^ RBParser parseRewriteExpression: aString
]

{ #category : #actions }
AbstractPanelPresenter >> recurseInto [
	self executeCommand: RecurseIntoCommand withSource: ''
]

{ #category : #alerts }
AbstractPanelPresenter >> replacementNotPossibleAlert [
	UIManager default
		alert: 'Can not replace this node, because it declars a metavariable which also is in rhs expression.'
		title: 'Alert'
]

{ #category : #accessing }
AbstractPanelPresenter >> statementIndex [
	^ nil
]

{ #category : #accessing }
AbstractPanelPresenter >> textModel [
	^ textModel
]

{ #category : #accessing }
AbstractPanelPresenter >> tool [
	^ self owner owner
]

{ #category : #actions }
AbstractPanelPresenter >> undoOnNode [
	self executeCommand: UndoOnNodeCommand withSource: ''
]

{ #category : #updating }
AbstractPanelPresenter >> updateAst [
	textModel ast: (self parse: textModel text)
]

{ #category : #updating }
AbstractPanelPresenter >> updateInfoFor: oldAst withOld: oldNode andNew: newNode [
	| myNewNode |
	self updateTextAndAst.
	myNewNode := newNode ifNil: [ textModel getSelectedNode ].
	textModel ast
		nodesDo: [ :each | 
			each = myNewNode
				ifTrue: [ 
					each oldNodes add: oldNode.
					self updateNextPanelForNode: each ] ].
	self addOldNodes: oldAst
]

{ #category : #updating }
AbstractPanelPresenter >> updateNextPanelForNode: aNode [
]

{ #category : #updating }
AbstractPanelPresenter >> updateSelection [
	^ nil
]

{ #category : #updating }
AbstractPanelPresenter >> updateText [
	textModel text: textModel ast formattedCode
]

{ #category : #updating }
AbstractPanelPresenter >> updateTextAndAst [
	self
		updateText;
		updateAst;
		yourself
]

{ #category : #accessing }
AbstractPanelPresenter >> varIndex [
	^ nil
]

{ #category : #alerts }
AbstractPanelPresenter >> varNotChosenAlert [
	UIManager default alert: 'Variable not chosen or does not exist.' title: 'Alert'
]
