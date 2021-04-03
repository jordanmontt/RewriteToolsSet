"
I am a subclass of AbstractPanel.
I Hold the transforming part of rewrite rule (rhs). Is also called ""replace with"".
"
Class {
	#name : #TransformPanelPresenter,
	#superclass : #AbstractPanelPresenter,
	#category : #'RewriteRuleBuilder-Panels'
}

{ #category : #updating }
TransformPanelPresenter >> addOldNodes: oldAst [

	oldAst nodesDo: [ :each | 
		codePresenter ast nodesDo: [ :newEach | 
			each = newEach ifTrue: [ newEach oldNodes addAll: each oldNodes ] ] ]
]

{ #category : #updating }
TransformPanelPresenter >> chooseMetavariablesForNode: aNode [

	| anIndex availableOptions |
	availableOptions := self owner matchPanel varNames collect: [ :each | 
		                    each name asString ].
	^ availableOptions
		  ifNotEmpty: [ 
			  anIndex := aNode command index ifNil: [ 
				             UIManager default
					             chooseFrom: availableOptions
					             title:
					             'Choose abstract name for: ' , aNode name asString ].
			  anIndex = 0
				  ifTrue: [ 
					  self varNotChosenAlert.
					  0 ]
				  ifFalse: [ (self owner matchPanel varNames at: anIndex) copy ] ]
		  ifEmpty: [ 
			  self noMetavariablesAlert.
			  0 ]
]

{ #category : #updating }
TransformPanelPresenter >> chooseTempsForNode: aNode [

	| anIndex temps availableOptions |
	temps := self owner matchPanel getTemporaries.
	availableOptions := temps collect: [ :each | each name asString ].
	^ availableOptions
		  ifNotEmpty: [ 
			  anIndex := aNode command index ifNil: [ 
				             UIManager default
					             chooseFrom: availableOptions
					             title: 'Choose abstract name for: '
						             ,
						             (aNode formattedCode
							              copyFrom: aNode leftBar
							              to: aNode rightBar) ].
			  anIndex = 0
				  ifTrue: [ 
					  self varNotChosenAlert.
					  0 ]
				  ifFalse: [ (temps at: anIndex) copy ] ]
		  ifEmpty: [ 
			  self noMetavariablesAlert.
			  0 ]
]

{ #category : #initialization }
TransformPanelPresenter >> initializePresenters [

	super initializePresenters.
	codePresenter syntaxHighlight: false
]

{ #category : #testing }
TransformPanelPresenter >> isReplacementPossibleFor: aNode [
	^ true
]

{ #category : #initialization }
TransformPanelPresenter >> labelName [

	^ 'Replace with'
]

{ #category : #initialization }
TransformPanelPresenter >> menuActions [

	"| options |
	options := super menuActions.
	self removeUnavailableOptions: options.
	^ options"
	^ {  }
]

{ #category : #updating }
TransformPanelPresenter >> removeUnavailableOptions: options [

	| position |
	position := options indexOf: #( 'As list' #asList ).
	position ~= 0 ifTrue: [ options removeAt: position ].
	position := options indexOf: #( 'Recurse into' #recurseInto ).
	position ~= 0 ifTrue: [ options removeAt: position ].
	position := options indexOf: #( 'Undo on node' #undoOnNode ).
	position ~= 0 ifTrue: [ options removeAt: position ]
]

{ #category : #updating }
TransformPanelPresenter >> updateSelection [

	| selectedNode |
	selectedNode := codePresenter getSelectedNode.
	self owner matchPanel ast allChildren do: [ :each | 
		each = selectedNode ifTrue: [ 
			codePresenter selectionInterval: selectedNode sourceInterval.
			self owner matchPanel codePresenter selectionInterval:
				codePresenter selectionInterval ] ]
]
