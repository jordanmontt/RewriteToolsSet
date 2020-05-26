"
A TransformPanel is a subclass of AbstractPanel.
Holds transforming part of rewrite rule.
Located in bottom right part of RewriteRuleBuilder.
"
Class {
	#name : #ReplaceWithCodePresenter,
	#superclass : #AbstractRuleCodePresenter,
	#category : #'RewriteToolToRefactor-SharedPresenters'
}

{ #category : #updating }
ReplaceWithCodePresenter >> addOldNodes: oldAst [
	oldAst
		nodesDo: [ :each | 
			codePresenter ast
				nodesDo: [ :newEach | 
					each = newEach
						ifTrue: [ newEach oldNodes addAll: each oldNodes ] ] ]
]

{ #category : #updating }
ReplaceWithCodePresenter >> chooseMetavariablesForNode: aNode [
	| anIndex availableOptions |
	availableOptions := self owner searchForPanel varNames collect: [ :each | each name asString ].
	availableOptions
		ifNotEmpty: [ 
			anIndex := aNode command index
				ifNil: [ UIManager default chooseFrom: availableOptions title: 'Choose abstract name for: ' , aNode name asString ].
			anIndex = 0
				ifTrue: [ 
					self varNotChosenAlert.
					^ 0 ]
				ifFalse: [ ^ (self owner searchForPanel varNames at: anIndex) copy ] ]
		ifEmpty: [ 
			self noMetavariablesAlert.
			^ 0 ]
]

{ #category : #updating }
ReplaceWithCodePresenter >> chooseTempsForNode: aNode [
	| anIndex temps availableOptions |
	temps := self owner searchForPanel getTemporaries.
	availableOptions := temps collect: [ :each | each name asString ].
	availableOptions
		ifNotEmpty: [ 
			anIndex := aNode command index
				ifNil: [ 
					UIManager default
						chooseFrom: availableOptions
						title: 'Choose abstract name for: ' , (aNode formattedCode copyFrom: aNode leftBar to: aNode rightBar) ].
			anIndex = 0
				ifTrue: [ 
					self varNotChosenAlert.
					^ 0 ]
				ifFalse: [ ^ (temps at: anIndex) copy ] ]
		ifEmpty: [ 
			self noMetavariablesAlert.
			^ 0 ]
]

{ #category : #initialization }
ReplaceWithCodePresenter >> initializePresenters [
	super initializePresenters.
	codePresenter syntaxHighlight: false.
	label label: 'Replace with:'
]

{ #category : #testing }
ReplaceWithCodePresenter >> isReplacementPossibleFor: aNode [
	^ true
]

{ #category : #initialization }
ReplaceWithCodePresenter >> menuActions [
	| options |
	options := super menuActions.
	self removeUnavailableOptions: options.
	^ options
]

{ #category : #updating }
ReplaceWithCodePresenter >> removeUnavailableOptions: options [
	| position |
	position := options indexOf: #('As list' #asList).
	position ~= 0
		ifTrue: [ options removeAt: position ].
	position := options indexOf: #('Recurse into' #recurseInto).
	position ~= 0
		ifTrue: [ options removeAt: position ].
	position := options indexOf: #('Undo on node' #undoOnNode).
	position ~= 0
		ifTrue: [ options removeAt: position ]
]

{ #category : #updating }
ReplaceWithCodePresenter >> updateNextPanelForNode: aNode [
	| rewriter |
	rewriter := RBParseTreeRewriter new
		replace: self owner searchForPanel codePresenter text
		with: codePresenter text.
	self flag: #accessOwner.
	"Tool is same as owner"
	self tool sourcePanel updateAst.
	self flag: #accessOwner.
	(rewriter executeTree: self tool sourcePanel codePresenter ast)
		ifTrue: [ self tool resultPanel codePresenter ast: rewriter tree ].
	self tool resultPanel updateText
]

{ #category : #updating }
ReplaceWithCodePresenter >> updateSelection [
	| selectedNode |
	selectedNode := codePresenter getSelectedNode.
	self owner searchForPanel textModel ast allChildren
		do: [ :each | 
			each = selectedNode
				ifTrue: [ codePresenter widget widget setSelection: selectedNode sourceInterval.
					self owner searchForPanel textModel
						setSelection:
							codePresenter getSelection ] ]
]
