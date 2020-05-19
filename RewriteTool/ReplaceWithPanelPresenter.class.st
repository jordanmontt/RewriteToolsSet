"
A TransformPanel is a subclass of AbstractPanel.
Holds transforming part of rewrite rule.
Located in bottom right part of RewriteRuleBuilder.
"
Class {
	#name : #ReplaceWithPanelPresenter,
	#superclass : #AbstractPanelPresenter,
	#category : #'RewriteTool-CommonPresenters'
}

{ #category : #updating }
ReplaceWithPanelPresenter >> addOldNodes: oldAst [
	oldAst
		nodesDo: [ :each | 
			textModel ast
				nodesDo: [ :newEach | 
					each = newEach
						ifTrue: [ newEach oldNodes addAll: each oldNodes ] ] ]
]

{ #category : #updating }
ReplaceWithPanelPresenter >> chooseMetavariablesForNode: aNode [
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
ReplaceWithPanelPresenter >> chooseTempsForNode: aNode [
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
ReplaceWithPanelPresenter >> initializePresenters [
	super initializePresenters.
	textModel syntaxHighlight: false
]

{ #category : #testing }
ReplaceWithPanelPresenter >> isReplacementPossibleFor: aNode [
	^ true
]

{ #category : #initialization }
ReplaceWithPanelPresenter >> menuActions [
	| options |
	options := super menuActions.
	self removeUnavailableOptions: options.
	^ options
]

{ #category : #updating }
ReplaceWithPanelPresenter >> removeUnavailableOptions: options [
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
ReplaceWithPanelPresenter >> updateNextPanelForNode: aNode [
	| rewriter |
	rewriter := RBParseTreeRewriter new
		replace: self owner searchForPanel textModel text
		with: textModel text.
	self flag: #accessOwner.
	"Tool is same as owner"
	self tool sourcePanel updateAst.
	self flag: #accessOwner.
	(rewriter executeTree: self tool sourcePanel textModel ast)
		ifTrue: [ self tool resultPanel textModel ast: rewriter tree ].
	self tool resultPanel updateText
]

{ #category : #updating }
ReplaceWithPanelPresenter >> updateSelection [
	| selectedNode |
	selectedNode := textModel getSelectedNode.
	self owner searchForPanel textModel ast allChildren
		do: [ :each | 
			each = selectedNode
				ifTrue: [ textModel widget widget setSelection: selectedNode sourceInterval.
					self owner searchForPanel textModel
						setSelection:
							textModel getSelection ] ]
]
