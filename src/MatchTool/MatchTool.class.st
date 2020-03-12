"
This is a tool that allows one to test and explore RB matching expressions.

MatchTool new openWithSpec
"
Class {
	#name : #MatchTool,
	#superclass : #SpPresenter,
	#instVars : [
		'matchExpression',
		'testExpression',
		'resultList',
		'matchMap',
		'executeButton',
		'helpButton'
	],
	#category : #'MatchTool-Presenters'
}

{ #category : #specs }
MatchTool class >> defaultSpec [
	| expressionsCol resultsCol buttonsSection |
	expressionsCol := SpBoxLayout newVertical
		add: #matchExpression;
		add: #testExpression;
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
		add: expressionsCol
			withConstraints: [ :constraints | constraints padding: 5 ];
		add: resultsCol
			withConstraints: [ :constraints | constraints padding: 5 ];
		add: #matchMap
			withConstraints: [ :constraints | constraints padding: 5 ];
		yourself
]

{ #category : #menu }
MatchTool class >> worldMenu: aBuilder [
	<worldMenu>
	(aBuilder item: #MatchTool)
		order: 0.40;
		icon: (self iconNamed: #jigsawIcon);
		parent: #Tools;
		help:
			'MatchTool is a simple UI for experimenting with the matching functionality of pattern code';
		action: [ self new openWithSpec ]
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

{ #category : #accessing }
MatchTool >> helpButton [
	^ helpButton
]

{ #category : #api }
MatchTool >> initialExtent [
	
	^ 900 @ 450
]

{ #category : #initialization }
MatchTool >> initializeFocusOrder [
	self focusOrder
		add: matchExpression;
		add: testExpression;
		add: executeButton;
		add: resultList;
		add: matchMap.
]

{ #category : #initialization }
MatchTool >> initializeMatchLists [
	| expressionCol matchCol |
	resultList
		disable;
		display: [ :assoc | assoc key formattedCode ].
	expressionCol := 
		(SpStringTableColumn title: 'Pattern' evaluated: [ :assoc | assoc key formattedCode ])
			yourself.
	matchCol :=
		(SpStringTableColumn title: 'Match' evaluated: [ :assoc | assoc value formattedCode ])
			yourself.
	matchMap
		addColumn: expressionCol;
		addColumn: matchCol;
			beResizable.
]

{ #category : #initialization }
MatchTool >> initializePresenters [
	self instantiateWidgets.
	matchExpression
		label: 'Pattern code';
		beForPatternCode.
	testExpression label: 'Test code'.
	executeButton
		icon:
			(self iconNamed: #smallDoIt);
		label: 'Match';
		shortcut: Character cr meta.
	helpButton
		icon: ((self iconNamed: #questionIcon) scaledToSize: 22 @ 22);
		shortcut: $h meta.
	self initializeMatchLists.
	self initializeFocusOrder
]

{ #category : #initialization }
MatchTool >> initializeWindow: aWindowPresenter [
	"override this to set window values before opening. 
	 You may want to add a menu, a toolbar or a statusbar"
	aWindowPresenter
		title: self title;
		initialExtent: self initialExtent;
		windowIcon: self windowIcon;
		askOkToClose: self askOkToClose;
		aboutText: self aboutText
]

{ #category : #initialization }
MatchTool >> instantiateWidgets [
	matchExpression := self instantiate: MatchToolSnippetPresenter.
	testExpression := self instantiate: MatchToolSnippetPresenter.
	resultList := self newList.
	executeButton := self newButton.
	helpButton := self newButton.
	matchMap := self newTable.
	"matchMap := self newList."
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
MatchTool >> matchMap [
	^ matchMap
]

{ #category : #'event handling' }
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

{ #category : #'event handling' }
MatchTool >> resultsChanged: newItems [
	matchMap items: #().
	resultList unselectAll.
	^ newItems
		ifEmpty: [ resultList borderColor: Color red ]
		ifNotEmpty: [ resultList borderColor: Color green ]
]

{ #category : #'event handling' }
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

{ #category : #testing }
MatchTool >> testMethodDeactivated [

	matchExpression isForMethod: false
]

{ #category : #api }
MatchTool >> title [

	^ 'MatchTool'
]

{ #category : #api }
MatchTool >> windowIcon [
	^ self iconNamed: #jigsawIcon
]
