"
This is a tool that allows one to test and explore RB matching expressions.

MatchTool new openWithSpec
"
Class {
	#name : #MatchToolPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'executeButton',
		'ruleEditor',
		'codeEditor',
		'bindingsTable',
		'matchesList'
	],
	#category : #'MatchTool-Presenters'
}

{ #category : #specs }
MatchToolPresenter class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		  add: (SpBoxLayout newVertical
				   add: #ruleEditor;
				   add: #codeEditor;
				   yourself);
		  add: (SpBoxLayout newVertical
				   add: #executeButton expand: false;
				   add: #matchesList;
				   yourself);
		  add: #bindingsTable;
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

{ #category : #defaults }
MatchToolPresenter >> addIconToTheme [
	"This method adds a custom jigsawIcon to the current theme, if absent."
	self theme icons icons
		at: #jigsawIcon
		ifAbsentPut: [ 
		Form fromBinaryStream: self iconContent base64Decoded readStream ]
]

{ #category : #initialization }
MatchToolPresenter >> connectPresenters [
	executeButton action: [ self performMatching ].
	ruleEditor
		whenCodeEdited: [ self disableLists ];
		whenMethodStateChangedDo: [ self disableLists ].
	codeEditor
		whenCodeEdited: [ self disableLists ];
		whenMethodStateChangedDo: [ self disableLists ].
	matchesList
		whenSelectionChangedDo: [ :selection | self selectedMatchChanged: selection ];
		whenModelChangedDo: [ :newItems | self matchesChanged: newItems ]
]

{ #category : #'event handling' }
MatchToolPresenter >> disableLists [
	matchesList disable.
	bindingsTable disable.
]

{ #category : #defaults }
MatchToolPresenter >> iconContent [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAABx0lEQVQokWVSTWsTURQ9972ZpkSwpC0RN4GU0oWiqy7cVZD+AD/+gb/Hf+BKXSp04aaCS8WKViKlBARLCTSlIabEJjOZefceF5mJaXvhvdU9555z75H1xpaZJ0kzGLIs3Xz2fOPRk0mamMKMSqjBSDUa6YAYZRH03h/svh0c/3LeAwBk+kQEAgAOV0pcOhx8f/fS8hwiJRFIAiB5DQD4aOG03er8+OyjeAqZfSLiZlAAVDUNcM5FcXLek2k7L9FFhRARDaHWWLu7/bS6vEqJFmt1zbOCeg4TiUhBb3Zv+3HzwcM0TVWZa6Cy1AMRwACgkAQA5Hg40JBbCKYKEiLORyWkKCflKuBcp7WnWVaKdGGSdg+/achE3My7r91szmxc9HurzY2l2w0N6hcqB+/ffH39gqr1O5tmRpKcnwDQdH/n1d+zk7iyeNZu/f60G1eqx18+DE+OnI+mfX55aa2wQYq48Xm/83Ove7jf/riTj0cS+TAZV1fqK+v3LQTO1jpT5XyUDPqj3ql4L94Z6UT+HLWpAQB5ORrTUeKci+O5ZfhRvxsmyTQpV6Mxb0nK2GUXwzwZiYjxGuD/WYr7UkQsZGGSELh1w/4BoVf8Blsi4TsAAAAASUVORK5CYII='
]

{ #category : #initialization }
MatchToolPresenter >> initialize [
	super initialize.
	self addIconToTheme
]

{ #category : #initialization }
MatchToolPresenter >> initializePresenters [
	codeEditor := (self instantiate: CodeEditorPresenter)
		              label: 'Test code';
		              beForPharoCode;
		              yourself.
	ruleEditor := (self instantiate: CodeEditorPresenter)
		              label: 'Pattern code';
		              beForPatternCode;
		              withoutSyntaxHighlight;
		              yourself.
	matchesList := self newList
		               display: [ :assoc | assoc key formattedCode ];
		               disable;
		               yourself.
	executeButton := self newButton
		                 icon: (self iconNamed: #smallDoIt);
		                 label: 'Match';
		                 shortcut: Character cr meta;
		                 yourself.
	bindingsTable := self newTable
		                 addColumn: (SpStringTableColumn
				                  title: 'Pattern'
				                  evaluated: [ :assoc | assoc key formattedCode ]);
		                 addColumn: (SpStringTableColumn
				                  title: 'Bindings'
				                  evaluated: [ :assoc | assoc value formattedCode ]);
		                 beResizable;
		                 yourself.
	self focusOrder
		add: ruleEditor;
		add: codeEditor;
		add: executeButton;
		add: matchesList;
		add: bindingsTable
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
	bindingsTable items: #(  ).
	matchesList unselectAll.
	newItems
		  ifEmpty: [ matchesList borderColor: Color red ]
		  ifNotEmpty: [ matchesList borderColor: Color green ]
]

{ #category : #'event handling' }
MatchToolPresenter >> performMatching [
	| matches |
	"self saveChanges."
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

{ #category : #'event handling' }
MatchToolPresenter >> saveChanges [
	ruleEditor acceptCode.
	codeEditor acceptCode
]

{ #category : #'event handling' }
MatchToolPresenter >> selectedMatchChanged: assoc [
	assoc
		  ifNil: [ 
			  bindingsTable items: #(  ).
			  codeEditor clearCodeSelection ]
		  ifNotNil: [ 
			  bindingsTable items: assoc value associations.
			  codeEditor setCodeSelection: assoc key sourceInterval ]
]

{ #category : #'event handling' }
MatchToolPresenter >> updateMatchListItems: matches [
	matchesList enable.
	bindingsTable enable.
	matchesList items: matches
]
