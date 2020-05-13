"
This is a tool that allows one to test and explore RB matching expressions.

MatchTool new openWithSpec
"
Class {
	#name : #MatchToolPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'executeButton',
		'helpButton',
		'ruleEditor',
		'codeEditor',
		'bindingsTable',
		'matchesList'
	],
	#category : #'MatchTool-Presenters'
}

{ #category : #specs }
MatchToolPresenter class >> defaultSpec [
	| paddingConstraints buttonConstraints |
	paddingConstraints := [ :constraints | constraints padding: 2 ].
	buttonConstraints := [ :constraints | 
	constraints
		padding: 4;
		height: 34 ].
	^ SpBoxLayout newHorizontal
		add:
			(SpBoxLayout newVertical
				add: #ruleEditor;
				add: #codeEditor;
				yourself)
			withConstraints: paddingConstraints;
		add:
			(SpBoxLayout newVertical
				add: #executeButton withConstraints: buttonConstraints;
				add: #matchesList;
				yourself)
			withConstraints: paddingConstraints;
		add: #bindingsTable withConstraints: paddingConstraints;
		yourself
]

{ #category : #properties }
MatchToolPresenter class >> descriptionText [
	^ 'MatchTool is a simple UI for experimenting with the matching functionality of pattern code'
]

{ #category : #properties }
MatchToolPresenter class >> icon [
	^ (self iconNamed: #jigsawIcon) scaledToSize: 16 @ 16
]

{ #category : #menu }
MatchToolPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #MatchTool)
		action: [ self open ];
		order: 20;
		parent: #Tools;
		help: self descriptionText;
		icon: self icon
]

{ #category : #api }
MatchToolPresenter class >> open [
	<script>
	^ self new openWithSpec
]

{ #category : #initialization }
MatchToolPresenter >> addIconToTheme [
	self iconNamed: #jigsawIcon
]

{ #category : #initialization }
MatchToolPresenter >> connectPresenters [
	ruleEditor
		whenCodeEdited: [ self disableLists ];
		whenMethodStateChangedDo: [ self disableLists ].
	"	whenMethodActivatedDo: [ ruleEditor isForMethod: true ];
		whenMethodDeactivatedDo: [ ruleEditor isForMethod: false ]."
	codeEditor
		whenCodeEdited: [ self disableLists ];
		whenMethodStateChangedDo: [ self disableLists ].
	"	whenMethodActivatedDo: [ codeEditor isForMethod: true ];
		whenMethodDeactivatedDo: [ codeEditor isForMethod: false ]."
	executeButton action: [ self performMatching ].
	"helpButton action: [ HelpBrowser openOn: MatchToolHelp ]."
	matchesList
		whenSelectionChangedDo: [ :selection | 
			[ :assoc | self selectedMatchItemChanged: assoc ]
				cull: selection selectedItem ];
		whenModelChangedDo: [ :newItems | self matchesChanged: newItems ]
]

{ #category : #defaults }
MatchToolPresenter >> disableLists [
	matchesList disable.
	bindingsTable disable.
]

{ #category : #initialization }
MatchToolPresenter >> initialize [
super initialize .
self addIconToTheme.
]

{ #category : #initialization }
MatchToolPresenter >> initializeBindingsTable [
	bindingsTable := self newTable.
	bindingsTable
		addColumn:
			(SpStringTableColumn
				title: 'Pattern'
				evaluated: [ :assoc | assoc key formattedCode ]);
		addColumn:
			(SpStringTableColumn
				title: 'Bindings'
				evaluated: [ :assoc | assoc value formattedCode ]);
		beResizable
]

{ #category : #initialization }
MatchToolPresenter >> initializeCodeEditor [
	codeEditor := self instantiate: CodeEditorPresenter.
	codeEditor
		label: 'Test code';
		parser: RBParser
]

{ #category : #initialization }
MatchToolPresenter >> initializeExecuteButton [
	executeButton := self newButton.
	executeButton
		icon: (self iconNamed: #smallDoIt);
		label: 'Match';
		shortcut: Character cr meta
]

{ #category : #initialization }
MatchToolPresenter >> initializeHelpButton [
	helpButton := self newButton.
	helpButton
		icon: ((self iconNamed: #questionIcon) scaledToSize: 22 @ 22);
		shortcut: $h meta
]

{ #category : #initialization }
MatchToolPresenter >> initializePresenters [
	self initializeRuleEditor.
	self initializeCodeEditor.
	self initializeResultList.
	self initializeExecuteButton.
	"self initializeHelpButton."
	self initializeBindingsTable.
	self focusOrder
		add: ruleEditor;
		add: codeEditor;
		add: executeButton;
		add: matchesList;
		add: bindingsTable
]

{ #category : #initialization }
MatchToolPresenter >> initializeResultList [
	matchesList := self newList.
	matchesList
		disable;
		display: [ :assoc | assoc key formattedCode ]
]

{ #category : #initialization }
MatchToolPresenter >> initializeRuleEditor [
	ruleEditor := self instantiate: CodeEditorPresenter.
	ruleEditor
		label: 'Pattern code';
		parser: RBPatternParser
]

{ #category : #initialization }
MatchToolPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Match Tool';
		initialExtent: 900 @ 450;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #testing }
MatchToolPresenter >> isReadyForMatching [
	^ ruleEditor astNode isNotNil and: [ codeEditor astNode isNotNil ]
]

{ #category : #'event handling' }
MatchToolPresenter >> matchesChanged: newItems [
	bindingsTable items: #().
	matchesList unselectAll.
	^ newItems
		ifEmpty: [ matchesList borderColor: Color red ]
		ifNotEmpty: [ matchesList borderColor: Color green ]
]

{ #category : #'event handling' }
MatchToolPresenter >> performMatching [
	| matches |
	self saveChanges.
	self isReadyForMatching
		ifFalse: [ ^ self ].
	matches := OrderedCollection new.
	codeEditor astNode doSemanticAnalysis.
	codeEditor astNode
		nodesDo: [ :node | 
			ruleEditor astNode
				match: node
				onSuccess: [ :bindings | matches add: node -> bindings ]
				onFailure: [  ] ].
	self updateMatchListItems: matches
]

{ #category : #defaults }
MatchToolPresenter >> saveChanges [
	ruleEditor accept.
	codeEditor accept
]

{ #category : #'event handling' }
MatchToolPresenter >> selectedMatchItemChanged: assoc [
	^ assoc
		ifNil: [ bindingsTable items: #().
			codeEditor clearCodeSelection ]
		ifNotNil: [ bindingsTable items: assoc value associations.
			codeEditor setCodeSelection: assoc key sourceInterval ]
]

{ #category : #defaults }
MatchToolPresenter >> updateMatchListItems: matches [
	matchesList enable.
	bindingsTable enable.
	matchesList items: matches
]
