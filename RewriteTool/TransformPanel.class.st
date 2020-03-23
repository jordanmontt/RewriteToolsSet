"
A TransformPanel is a subclass of AbstractPanel.
Holds transforming part of rewrite rule.
Located in bottom right part of RewriteRuleBuilder.
"
Class {
	#name : #TransformPanel,
	#superclass : #AbstractPanel,
	#category : #'RewriteTool-Panels'
}

{ #category : #updating }
TransformPanel >> addOldNodes: oldAst [
	oldAst
		nodesDo: [ :each | 
			self textModel ast
				nodesDo: [ :newEach | 
					each = newEach
						ifTrue: [ newEach oldNodes addAll: each oldNodes ] ] ]
]

{ #category : #updating }
TransformPanel >> chooseMetavariablesForNode: aNode [
	| anIndex availableOptions |
	availableOptions := self owner matchPanel varNames collect: [ :each | each name asString ].
	availableOptions
		ifNotEmpty: [ 
			anIndex := aNode command index
				ifNil: [ UIManager default chooseFrom: availableOptions title: 'Choose abstract name for: ' , aNode name asString ].
			anIndex = 0
				ifTrue: [ 
					self varNotChosenAlert.
					^ 0 ]
				ifFalse: [ ^ (self owner matchPanel varNames at: anIndex) copy ] ]
		ifEmpty: [ 
			self noMetavariablesAlert.
			^ 0 ]
]

{ #category : #updating }
TransformPanel >> chooseTempsForNode: aNode [
	| anIndex temps availableOptions |
	temps := self owner matchPanel getTemporaries.
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
TransformPanel >> initializePresenters [
	super initializePresenters.
	self textModel syntaxHighlight: false
]

{ #category : #testing }
TransformPanel >> isReplacementPossibleFor: aNode [
	^ true
]

{ #category : #initialization }
TransformPanel >> menuActions [
	| options |
	options := super menuActions.
	self removeUnavailableOptions: options.
	^ options
]

{ #category : #updating }
TransformPanel >> removeUnavailableOptions: options [
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
TransformPanel >> updateNextPanelForNode: aNode [
	| rewriter |
	rewriter := RBParseTreeRewriter new replace: self owner matchPanel textModel text with: self textModel text.
	self tool sourcePanel updateAst.
	(rewriter executeTree: self tool sourcePanel textModel ast)
		ifTrue: [ self tool resultPanel textModel ast: rewriter tree ].
	self tool resultPanel updateText
]

{ #category : #updating }
TransformPanel >> updateSelection [
	| selectedNode |
	selectedNode := self textModel getSelectedNode.
	self owner matchPanel textModel ast allChildren
		do: [ :each | 
			each = selectedNode
				ifTrue: [ 
					self textModel widget widget setSelection: selectedNode sourceInterval.
					self owner matchPanel textModel setSelection: self textModel getSelection ] ]
]
