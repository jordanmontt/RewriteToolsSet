"
This is a tool that allows to test and explore RB matching expressions
"
Class {
	#name : #MatchTool,
	#superclass : #SpPresenter,
	#instVars : [
		'matchExpressionWrapper',
		'testExpressionWrapper',
		'matchExpression',
		'testExpression',
		'resultList',
		'matchMap',
		'executeButton',
		'helpButton'
	],
	#category : #MatchTool
}

{ #category : #specs }
MatchTool class >> defaultSpec [
	| expressionsCol resultsCol buttonsSection |
	expressionsCol := SpBoxLayout newVertical 
		add: #matchExpressionWrapper;
		add: #testExpressionWrapper;
		yourself.
	buttonsSection := SpBoxLayout newHorizontal 
		add: #executeButton; 
		add: #helpButton width: 30;
		yourself.
	resultsCol := SpBoxLayout newVertical
		add: buttonsSection height: 30;
		add: #resultList;
		yourself.
	^ SpBoxLayout newHorizontal
		add: expressionsCol;
		add: resultsCol;
		add: #matchMap;
		yourself.
"	^SpecLayout composed
		newColumn: [ :col | col
			add: #matchExpression;
			add: #testExpression. ]
		origin: 0 @ 0 corner: 0.46 @ 1;
		
		newColumn: [ :col | col
			newRow: [ :buttonRow | buttonRow
				add: #executeButton;
				add: #helpButton width: 30 ]
			height: 30;
			add: #resultList ]
		origin: 0.46 @ 0 corner: 0.73 @ 1;
		
		newColumn: [ :col | col
			add: #matchMap ]
		origin: 0.73 @ 0 corner: 1 @ 1;
		yourself"
]

{ #category : #menu }
MatchTool class >> worldMenu: aBuilder [
	<worldMenu>
	(aBuilder item: #MatchTool)
		order: 0.40;
		icon: (self iconNamed: #jigsawIcon);
		parent: #Tools;
		action: [ self new
				openWithSpec;
				disableLists.
			self
				flag:
					'use #disableLists here to overcome spec issue where #enabled: status is not set on widget construction' ]
]

{ #category : #initialization }
MatchTool >> connectPresenters [
	matchExpression
		whenCodeEdited: [ self disableLists ];
		whenMethodStateChangedDo: [ self disableLists ];
		whenMethodActivatedDo: [ self matchMethodActivated ].
	testExpression
		whenCodeEdited: [ self disableLists ];
		whenMethodStateChangedDo: [ self disableLists ];
		whenMethodDeactivatedDo: [ self testMethodDeactivated ].
	executeButton action: [ self performMatching ].
	helpButton action: [ HelpBrowser openOn: MatchToolHelp ].
	resultList
		whenSelectionChangedDo: [ :selection | 
			[ :assoc | self selectedResultsItemChanged: assoc ]
				cull: selection selectedItem ];
		whenModelChangedDo: [ :newItems | self resultsChanged: newItems ]
]

{ #category : #'event handling' }
MatchTool >> disableLists [
	resultList disable.
	matchMap disable.
]

{ #category : #accessing }
MatchTool >> executeButton [
	^ executeButton
]

{ #category : #api }
MatchTool >> extent [
	
	^ 800 @ 400
]

{ #category : #accessing }
MatchTool >> helpButton [
	^ helpButton
]

{ #category : #initialization }
MatchTool >> initializeFocusOrder [
	self focusOrder
		add: matchExpressionWrapper;
		add: testExpressionWrapper;
		add: executeButton;
		add: resultList
]

{ #category : #initialization }
MatchTool >> initializeLists [
	resultList
		disable;
		display: [ :assoc | assoc key formattedCode ].
	matchMap
		disable;
		selectionMode: (SpSingleSelectionMode on: self);
		display: [ :assoc | 
			{assoc key formattedCode.
			assoc value formattedCode} ]
]

{ #category : #initialization }
MatchTool >> initializePresenters [
	self instantiateWidgets.
	matchExpression  beForPatternCode.
	matchExpressionWrapper
		label: 'Pattern code';
		subwidget: matchExpression.
	testExpressionWrapper 
		label: 'Test code';
		subwidget: testExpression.
	executeButton
		icon:
			(self iconNamed: #smallDoIt);
		label: 'Match';
		shortcut: Character cr meta.
	helpButton
		icon: ((self iconNamed: #questionIcon) scaledToSize: 22 @ 22);
		shortcut: $h meta.
	self initializeLists.
	self initializeFocusOrder
]

{ #category : #initialization }
MatchTool >> instantiateWidgets [
	matchExpressionWrapper := self instantiate: SpLabelledContainer.
	testExpressionWrapper := self instantiate: SpLabelledContainer.
	matchExpression := self instantiate: MatchToolSnippetWidget.
	testExpression := self instantiate: MatchToolSnippetWidget.
	resultList := self newList.
	executeButton := self newButton.
	helpButton := self newButton.
	"matchMap := self newTable."
	matchMap := self newList.
]

{ #category : #testing }
MatchTool >> isReadyForMatching [

	^ (matchExpression hasUnacceptedEdits or: [ 
		testExpression  hasUnacceptedEdits or: [ 
		matchExpression astNode isNil or: [ 
		testExpression astNode isNil ] ] ]) not
]

{ #category : #accessing }
MatchTool >> matchExpression [
	^ matchExpression
]

{ #category : #accessing }
MatchTool >> matchExpressionWrapper [
	^ matchExpressionWrapper
]

{ #category : #accessing }
MatchTool >> matchMap [
	^ matchMap
]

{ #category : #initialization }
MatchTool >> matchMethodActivated [

	testExpression isForMethod: true
]

{ #category : #'event handling' }
MatchTool >> performMatching [
	| matches |
	matchExpression accept.
	testExpression  accept.
	
	self isReadyForMatching ifFalse: [ ^ self ].
	
	matches := OrderedCollection new.
	
	testExpression astNode doSemanticAnalysis.
	
	testExpression astNode nodesDo: [ :node |
		matchExpression astNode
			match: node
			onSuccess: [ :map |
				matches add: node -> map ]
			onFailure: [  ] ].
		
	resultList enable.
	matchMap   enable.
	resultList items: matches.
]

{ #category : #accessing }
MatchTool >> resultList [
	^ resultList
]

{ #category : #initialization }
MatchTool >> resultsChanged: newItems [
	matchMap items: #().
	resultList unselectAll.
	^ newItems
		ifEmpty: [ resultList borderColor: Color red ]
		ifNotEmpty: [ resultList borderColor: Color green ]
]

{ #category : #initialization }
MatchTool >> selectedResultsItemChanged: assoc [
	^ assoc
		ifNil: [ matchMap items: #().
			testExpression clearCodeSelection ]
		ifNotNil: [ matchMap items: assoc value associations.
			testExpression setCodeSelection: assoc key sourceInterval ]
]

{ #category : #accessing }
MatchTool >> testExpression [
	^ testExpression
]

{ #category : #accessing }
MatchTool >> testExpressionWrapper [
	^ testExpressionWrapper
]

{ #category : #initialization }
MatchTool >> testMethodDeactivated [

	matchExpression isForMethod: false
]

{ #category : #api }
MatchTool >> title [

	^ 'MatchTool'
]

{ #category : #api }
MatchTool >> windowIcon [

	^ Smalltalk ui icons jigsawIcon
]
