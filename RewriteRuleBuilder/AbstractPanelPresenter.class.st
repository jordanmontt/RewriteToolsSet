"
I am an abstract class. My subclasses are the four panels of `RewriteRuleBuilderPresenter` tool.
I am responsible for implementation of all actions that can be applied to ast nodes in RewriteRuleBuilder tool.
Also I update the ast and the text that is displayed.

"
Class {
	#name : #AbstractPanelPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'codePresenter',
		'submitButton'
	],
	#category : #'RewriteRuleBuilder-Panels'
}

{ #category : #specs }
AbstractPanelPresenter class >> defaultSpec [

	| submitButtonLayout |
	submitButtonLayout := SpBoxLayout newHorizontal
		                      add: #submitButton
		                      withConstraints: [ :constraints | 
			                      constraints
				                      expand: false;
				                      width: 80 ];
		                      yourself.
	^ SpBoxLayout newVertical
		  add: submitButtonLayout expand: false;
		  add: #codePresenter;
		  yourself
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

{ #category : #initialization }
AbstractPanelPresenter >> buildMenu [

	| actions aMenuPresenter |
	aMenuPresenter := self newMenu.
	self updateSelection.
	actions := self menuActions.
	actions do: [ :action | 
		aMenuPresenter addItem: [ :item | 
			item
				name: action first;
				action: [ self perform: action second ] ] ].
	^ aMenuPresenter
]

{ #category : #actions }
AbstractPanelPresenter >> change [

	| newSource |
	newSource := UIManager default
		             request: 'Enter new source instead of: '
			             , codePresenter getSelectedNode formattedCode
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

	UIManager default
		alert: 'Please input valid data.'
		title: 'Invalid input!'
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
AbstractPanelPresenter >> code: aString [

	codePresenter text: aString.
	codePresenter ast: (self parse: aString)
]

{ #category : #accessing }
AbstractPanelPresenter >> codePresenter [

	^ codePresenter
]

{ #category : #accessing }
AbstractPanelPresenter >> conditionIndex [
	^ nil
]

{ #category : #initialization }
AbstractPanelPresenter >> connectPresenters [

	submitButton action: [ codePresenter triggerSubmitAction ]
]

{ #category : #accessing }
AbstractPanelPresenter >> defaultCode [

	^ (self parse: '| temp | self isNil ifTrue: [ ^ true ]. temp size')
		  formattedCode
]

{ #category : #enumerating }
AbstractPanelPresenter >> difference: aCollection with: anotherCollection [
	anotherCollection do: [ :each | aCollection remove: each ifAbsent: [ nil ] ].
	^ aCollection
]

{ #category : #execute }
AbstractPanelPresenter >> executeCommand: aCommandClass withSource: aString [

	| node oldAst newNode tempNode |
	oldAst := codePresenter ast copy.
	node := codePresenter getSelectedNode.
	((self isReplacementPossibleFor: node) or: [ aCommandClass isTemps ])
		ifTrue: [ 
			codePresenter ast allChildren do: [ :each | 
				(each = node and: [ aCommandClass isAccepted: each ]) ifTrue: [ 
					tempNode := aCommandClass isSequenceNeeded
						            ifTrue: [ each getSequenceParent ]
						            ifFalse: [ each ].
					tempNode command:
						(aCommandClass
							 receiver: tempNode
							 panel: self
							 withSource: aString).
					newNode := tempNode command execute ] ].
			self manageUndoDictFor: oldAst.
			self updateInfoFor: oldAst withOld: tempNode copy andNew: newNode ]
		ifFalse: [ self replacementNotPossibleAlert ]
]

{ #category : #accessing }
AbstractPanelPresenter >> getAllMetavariables [

	^ codePresenter ast allChildren select: [ :each | 
		  each isPatternNode ]
]

{ #category : #accessing }
AbstractPanelPresenter >> getSelectedMetavarsFor: aNode [
	^ aNode allChildren select: [ :each | each isPatternNode and: [ each ~= aNode ] ]
]

{ #category : #initialization }
AbstractPanelPresenter >> initializePresenters [

	codePresenter := self instantiate: RRCodePresenter.
	codePresenter
		text: self defaultCode;
		ast: (self parse: self defaultCode);
		contextMenu: [ self buildMenu ];
		withoutLineNumbers.
	submitButton := self newButton
		                label: 'Submit code';
		                help: 'Triggers the submission action (cmd + s)'
]

{ #category : #testing }
AbstractPanelPresenter >> isReplacementPossibleFor: aNode [

	| selectedMetavars allMetavars usedMetavars |
	selectedMetavars := self getSelectedMetavarsFor: aNode.
	allMetavars := self getAllMetavariables.
	usedMetavars := self owner transformPanel getAllMetavariables.
	^ ((self difference: allMetavars copy with: selectedMetavars)
	   & selectedMetavars == selectedMetavars and: [ 
		   ((selectedMetavars & usedMetavars) isNotEmpty or: [ 
			    (selectedMetavars | usedMetavars) isEmpty ]) or: [ 
			   selectedMetavars isEmpty ] ]) or: [ 
		  self owner transformPanel codePresenter ast allChildren anySatisfy: [ 
			  :each | each = aNode ] ]
]

{ #category : #testing }
AbstractPanelPresenter >> isSelectedAll [

	^ codePresenter getSelectedNode formattedCode size
	  = codePresenter ast formattedCode size
]

{ #category : #accessing }
AbstractPanelPresenter >> literalIndex [
	^ nil
]

{ #category : #updating }
AbstractPanelPresenter >> manageUndoDictFor: oldAst [

	self owner undoDict add: (RewriteRuleChangesKeeper new
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
	options addAll: codePresenter getSelectedNode optionsForNode.
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
AbstractPanelPresenter >> tool [
	^ self owner owner
]

{ #category : #actions }
AbstractPanelPresenter >> undoOnNode [
	self executeCommand: UndoOnNodeCommand withSource: ''
]

{ #category : #updating }
AbstractPanelPresenter >> updateInfoFor: oldAst withOld: oldNode andNew: newNode [

	| myNewNode |
	self updateTextAndAst.
	myNewNode := newNode ifNil: [ codePresenter getSelectedNode ].
	codePresenter ast nodesDo: [ :each | 
		each = myNewNode ifTrue: [ 
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
AbstractPanelPresenter >> updateTextAndAst [

	codePresenter
		text: codePresenter ast formattedCode;
		ast: (self parse: codePresenter text)
]

{ #category : #accessing }
AbstractPanelPresenter >> varIndex [
	^ nil
]

{ #category : #alerts }
AbstractPanelPresenter >> varNotChosenAlert [
	UIManager default alert: 'Variable not chosen or does not exist.' title: 'Alert'
]
