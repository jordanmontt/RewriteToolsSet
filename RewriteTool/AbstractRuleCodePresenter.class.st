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
	#name : #AbstractRuleCodePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'codePresenter',
		'label'
	],
	#category : #'RewriteTool-SharedPresenters'
}

{ #category : #specs }
AbstractRuleCodePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #label height: 20;
		add: #codePresenter;
		yourself
]

{ #category : #accessing }
AbstractRuleCodePresenter class >> labelHeight [
	^ 30
]

{ #category : #actions }
AbstractRuleCodePresenter >> abstractBlock [
	self executeCommand: AbstractBlockCommand withSource: ''
]

{ #category : #actions }
AbstractRuleCodePresenter >> abstractCondition [
	self executeCommand: AbstractConditionCommand withSource: ''
]

{ #category : #actions }
AbstractRuleCodePresenter >> abstractLiteral [
	self executeCommand: AbstractLiteralCommand withSource: ''
]

{ #category : #actions }
AbstractRuleCodePresenter >> abstractMessage [
	self executeCommand: AbstractMessageCommand withSource: ''
]

{ #category : #actions }
AbstractRuleCodePresenter >> abstractStatement [
	self executeCommand: AbstractStatementCommand withSource: ''
]

{ #category : #actions }
AbstractRuleCodePresenter >> abstractStatements [
	self executeCommand: AbstractStatementsCommand withSource: ''
]

{ #category : #actions }
AbstractRuleCodePresenter >> abstractTemporariesList [
	self executeCommand: AbstractTemporariesListCommand withSource: ''
]

{ #category : #actions }
AbstractRuleCodePresenter >> abstractVariable [
	self executeCommand: AbstractVariableCommand withSource: ''
]

{ #category : #'undo-redo' }
AbstractRuleCodePresenter >> addChanges [
	self deprecated: 'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	^ nil
]

{ #category : #updating }
AbstractRuleCodePresenter >> addOldNodes: oldAst [
	^ nil
]

{ #category : #actions }
AbstractRuleCodePresenter >> asList [
	self executeCommand: AsListCommand withSource: ''
]

{ #category : #accessing }
AbstractRuleCodePresenter >> blockIndex [
	^ nil
]

{ #category : #actions }
AbstractRuleCodePresenter >> change [
	| newSource |
	newSource := UIManager default
		request:
			'Enter new source instead of: '
				,
					codePresenter getSelectedNode formattedCode
		initialAnswer: ''.
	(newSource = '' or: [ newSource isNil ])
		ifTrue: [ self changeInvalidAlert ]
		ifFalse: [ self executeCommand: RenameCommand withSource: newSource ]
]

{ #category : #actions }
AbstractRuleCodePresenter >> change: newSource [
	self executeCommand: RenameCommand withSource: newSource
]

{ #category : #alerts }
AbstractRuleCodePresenter >> changeInvalidAlert [
	UIManager default alert: 'Please input valid data.' title: 'Invalid input !'
]

{ #category : #updating }
AbstractRuleCodePresenter >> chooseMetavariablesForNode: aNode [
	^ nil
]

{ #category : #updating }
AbstractRuleCodePresenter >> chooseTempsForNode: aNode [
	^ nil
]

{ #category : #alerts }
AbstractRuleCodePresenter >> classNotCreatedAlert [
	UIManager default alert: 'Class not created.' title: 'Alert'
]

{ #category : #accessing }
AbstractRuleCodePresenter >> code [
	self deprecated: 'User codeSource'.
	^ nil
]

{ #category : #accessing }
AbstractRuleCodePresenter >> code: aString [
	self deprecated: 'Use codeSource:'.
	
]

{ #category : #accessing }
AbstractRuleCodePresenter >> codePresenter [
	self flag: #thisVariableShouldNotHaveAnAccessor.
	^ codePresenter
]

{ #category : #accessing }
AbstractRuleCodePresenter >> codeSource [
	"codePresenter text isEmptyOrNil
		ifTrue: [ ^ (self parse: '| temp | self isNil ifTrue: [ ^ true ]. temp size')
				formattedCode ]."
	^ codePresenter text
]

{ #category : #accessing }
AbstractRuleCodePresenter >> codeSource: aCodeBlock [
	| codeAsNode |
	codeAsNode := self parse: aCodeBlock.
	codePresenter text: codeAsNode formattedCode.
	codePresenter ast: codeAsNode
]

{ #category : #accessing }
AbstractRuleCodePresenter >> conditionIndex [
	^ nil
]

{ #category : #enumerating }
AbstractRuleCodePresenter >> difference: aCollection with: anotherCollection [
	anotherCollection do: [ :each | aCollection remove: each ifAbsent: [ nil ] ].
	^ aCollection
]

{ #category : #execute }
AbstractRuleCodePresenter >> executeCommand: aCommandClass withSource: aString [
	| node oldAst newNode tempNode |
	oldAst := codePresenter ast copy.
	node := codePresenter getSelectedNode.
	((self isReplacementPossibleFor: node) or: [ aCommandClass isTemps ])
		ifTrue: [ codePresenter ast allChildren
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
AbstractRuleCodePresenter >> getAllMetavariables [
	^ codePresenter ast allChildren select: [ :each | each isPatternNode ]
]

{ #category : #accessing }
AbstractRuleCodePresenter >> getSelectedMetavarsFor: aNode [
	^ aNode allChildren select: [ :each | each isPatternNode and: [ each ~= aNode ] ]
]

{ #category : #initialization }
AbstractRuleCodePresenter >> initializePresenters [
	codePresenter := self instantiate: RRTextModelPresenter.
	codePresenter
		dragEnabled;
		text: self codeSource;
		ast: (self parse: self codeSource);
		syntaxHighlight: true;
		model: self;
		menuOptions: #menuActions.
	label := self newLabel.
]

{ #category : #testing }
AbstractRuleCodePresenter >> isReplacementPossibleFor: aNode [
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
AbstractRuleCodePresenter >> isSelectedAll [
	^ codePresenter getSelectedNode formattedCode size = codePresenter ast formattedCode size
]

{ #category : #accessing }
AbstractRuleCodePresenter >> literalIndex [
	^ nil
]

{ #category : #'undo-redo' }
AbstractRuleCodePresenter >> manageUndoDictFor: oldAst [
	self
		deprecated:
			'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
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
AbstractRuleCodePresenter >> menuActions [
	| options |
	options := OrderedCollection new.
	options addAll: codePresenter getSelectedNode optionsForNode.
	^ options
]

{ #category : #alerts }
AbstractRuleCodePresenter >> noMetavariablesAlert [
	UIManager default alert: 'No available metavariables for selected node.' title: 'Alert'
]

{ #category : #parsing }
AbstractRuleCodePresenter >> parse: aString [
	^ RBParser parseRewriteExpression: aString
]

{ #category : #actions }
AbstractRuleCodePresenter >> recurseInto [
	self executeCommand: RecurseIntoCommand withSource: ''
]

{ #category : #alerts }
AbstractRuleCodePresenter >> replacementNotPossibleAlert [
	UIManager default
		alert: 'Can not replace this node, because it declars a metavariable which also is in rhs expression.'
		title: 'Alert'
]

{ #category : #accessing }
AbstractRuleCodePresenter >> statementIndex [
	^ nil
]

{ #category : #accessing }
AbstractRuleCodePresenter >> textModel [
	self deprecated: 'User codePresenter'.
	^ codePresenter
]

{ #category : #accessing }
AbstractRuleCodePresenter >> tool [
	self flag: #thisIsTrulyWrong.
	^ self owner owner
]

{ #category : #'undo-redo' }
AbstractRuleCodePresenter >> undoOnNode [
	self
		deprecated:
			'Redo and Undo functions are unnecessary and are implemented in a complex, and very coupled way.'.
	self executeCommand: UndoOnNodeCommand withSource: ''
]

{ #category : #updating }
AbstractRuleCodePresenter >> updateAst [
	codePresenter ast: (self parse: codePresenter text)
]

{ #category : #updating }
AbstractRuleCodePresenter >> updateInfoFor: oldAst withOld: oldNode andNew: newNode [
	| myNewNode |
	self updateTextAndAst.
	myNewNode := newNode ifNil: [ codePresenter getSelectedNode ].
	codePresenter ast
		nodesDo: [ :each | 
			each = myNewNode
				ifTrue: [ 
					each oldNodes add: oldNode.
					self updateNextPanelForNode: each ] ].
	self addOldNodes: oldAst
]

{ #category : #updating }
AbstractRuleCodePresenter >> updateNextPanelForNode: aNode [
]

{ #category : #updating }
AbstractRuleCodePresenter >> updateSelection [
	^ nil
]

{ #category : #updating }
AbstractRuleCodePresenter >> updateText [
	codePresenter text: codePresenter ast formattedCode
]

{ #category : #updating }
AbstractRuleCodePresenter >> updateTextAndAst [
	self
		updateText;
		updateAst;
		yourself
]

{ #category : #accessing }
AbstractRuleCodePresenter >> varIndex [
	^ nil
]

{ #category : #alerts }
AbstractRuleCodePresenter >> varNotChosenAlert [
	UIManager default alert: 'Variable not chosen or does not exist.' title: 'Alert'
]
