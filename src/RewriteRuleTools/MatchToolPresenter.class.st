"
I am a tool that allows you to match and test a pattern code with Pharo's code. To open me: `MatchToolPresenter open`

Write the pattern's code and the Pharo's code in the code editors and then press the 'Match' button. After that, I will match all ocurrences of the pattern code on the Pharo's code.

- The middle column shows all the occurrences that the pattern code has in the Pharo's code.
- The right column shows all the bindings of the selected matched of the middle column.
"
Class {
	#name : #MatchToolPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'executeButton',
		'ruleEditor',
		'codeEditor',
		'bindingsTable',
		'matchesList',
		'codeLabel',
		'methodCheckbox',
		'astPattern',
		'astCode'
	],
	#category : #'RewriteRuleTools-MatchTool'
}

{ #category : #accessing }
MatchToolPresenter class >> descriptionText [
	^ 'MatchTool is a simple UI for experimenting with the matching functionality of a rewrite rule'
]

{ #category : #accessing }
MatchToolPresenter class >> icon [

	^ self iconNamed: self iconName
]

{ #category : #accessing }
MatchToolPresenter class >> iconName [

	| iconContent |
	iconContent := 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAABx0lEQVQokWVSTWsTURQ9972ZpkSwpC0RN4GU0oWiqy7cVZD+AD/+gb/Hf+BKXSp04aaCS8WKViKlBARLCTSlIabEJjOZefceF5mJaXvhvdU9555z75H1xpaZJ0kzGLIs3Xz2fOPRk0mamMKMSqjBSDUa6YAYZRH03h/svh0c/3LeAwBk+kQEAgAOV0pcOhx8f/fS8hwiJRFIAiB5DQD4aOG03er8+OyjeAqZfSLiZlAAVDUNcM5FcXLek2k7L9FFhRARDaHWWLu7/bS6vEqJFmt1zbOCeg4TiUhBb3Zv+3HzwcM0TVWZa6Cy1AMRwACgkAQA5Hg40JBbCKYKEiLORyWkKCflKuBcp7WnWVaKdGGSdg+/achE3My7r91szmxc9HurzY2l2w0N6hcqB+/ffH39gqr1O5tmRpKcnwDQdH/n1d+zk7iyeNZu/f60G1eqx18+DE+OnI+mfX55aa2wQYq48Xm/83Ove7jf/riTj0cS+TAZV1fqK+v3LQTO1jpT5XyUDPqj3ql4L94Z6UT+HLWpAQB5ORrTUeKci+O5ZfhRvxsmyTQpV6Mxb0nK2GUXwzwZiYjxGuD/WYr7UkQsZGGSELh1w/4BoVf8Blsi4TsAAAAASUVORK5CYII='.
	self theme icons icons
		at: #jigsawIcon
		ifAbsentPut: [ 
		Form fromBinaryStream: iconContent base64Decoded readStream ].
	
	^ #jigsawIcon
]

{ #category : #menu }
MatchToolPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'Match Tool')
		action: [ self open ];
		order: 32;
		parent: #Tools;
		help: self descriptionText;
		icon: self icon
]

{ #category : #api }
MatchToolPresenter class >> open [
	<example>
	^ RTApplication new startMatchTool
]

{ #category : #specs }
MatchToolPresenter class >> title [

	^ 'Match Tool'
]

{ #category : #initialization }
MatchToolPresenter >> connectPresenters [

	matchesList
		whenSelectionChangedDo: [ :selection | 
			self selectedMatchChanged: selection ];
		whenModelChangedDo: [ :newItems | self matchesChanged ].
	executeButton action: [ self performMatching ]
]

{ #category : #actions }
MatchToolPresenter >> emptyLists [

	bindingsTable items: #(  ).
	matchesList items: #(  )
]

{ #category : #defaults }
MatchToolPresenter >> getBindingsItemsForMatch: bindingsAssociation [

	| newItems |
	newItems := OrderedCollection new.
	bindingsAssociation keysAndValuesDo: [ :key :value | 
		(value isKindOf: OrderedCollection)
			ifTrue: [ newItems add: (value collect: [ :each | key -> each ]) ]
			ifFalse: [ newItems add: key -> value ] ].
	^ newItems flattened
]

{ #category : #initialization }
MatchToolPresenter >> initializeButtons [

	executeButton := self newButton.
	executeButton
		icon: (self iconNamed: #smallDoIt);
		label: 'Match';
		shortcut: Character cr meta.
]

{ #category : #initialization }
MatchToolPresenter >> initializeEditors [

	methodCheckbox := self newCheckBox label: 'Is rule for method?'.
	
	codeLabel := self newLabel label: 'Pharo code'.
	
	codeEditor := self newCode.
	codeEditor
		withoutLineNumbers;
		beForScripting;
		text: DefaultRule new inputCode.

	ruleEditor := self instantiate: RTSearchForPanel.
]

{ #category : #initialization }
MatchToolPresenter >> initializeLayout [

	| rulePanel codePanel matchesWithLabelPanel |
	rulePanel := SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: methodCheckbox expand: false;
			addLast: executeButton expand: false;
			yourself)
		expand: false;
		add: ruleEditor;
		yourself.
	codePanel := SpBoxLayout newTopToBottom
		add: codeLabel expand: false;
		add: codeEditor;
		yourself.
	matchesWithLabelPanel := SpBoxLayout newTopToBottom
		add: (self newLabel label: 'Matches') expand: false;
		add: matchesList;
		yourself.

	self layout: (SpPanedLayout newLeftToRight
		add: (SpPanedLayout newTopToBottom
			add: rulePanel;
			add: codePanel;
			yourself);
		add: (SpPanedLayout newLeftToRight
			add: matchesWithLabelPanel;
			add: bindingsTable;
			yourself);
		yourself)
]

{ #category : #initialization }
MatchToolPresenter >> initializeMatchesPresenters [

	matchesList := self newList.
	matchesList display: [ :assoc | assoc key formattedCode ].

	bindingsTable := self newTable.
	bindingsTable
		addColumn: (SpStringTableColumn
			title: 'Pattern'
			evaluated: [ :assoc | assoc key formattedCode ]);
		addColumn: (SpStringTableColumn
			title: 'Bindings'
			evaluated: [ :assoc | assoc value formattedCode ]);
		beResizable.
]

{ #category : #initialization }
MatchToolPresenter >> initializePresenters [
	
	self initializeEditors.
	self initializeButtons.
	self initializeMatchesPresenters.
	self initializeLayout.
	
	self focusOrder
		add: ruleEditor;
		add: codeEditor
]

{ #category : #initialization }
MatchToolPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 800 @ 450;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #'event handling' }
MatchToolPresenter >> matchesChanged [

	bindingsTable items: #(  ).
	matchesList unselectAll
]

{ #category : #actions }
MatchToolPresenter >> parseCodeAST [

	astCode := methodCheckbox state
		           ifTrue: [ RBParser parseMethod: codeEditor text ]
		           ifFalse: [ RBParser parseExpression: codeEditor text ]
]

{ #category : #actions }
MatchToolPresenter >> parsePatternAST [

	astPattern := methodCheckbox state
		ifTrue: [ RBPatternParser parseMethod: ruleEditor lhs ]
		ifFalse: [ RBPatternParser parseExpression: ruleEditor lhs ].
		
]

{ #category : #accessing }
MatchToolPresenter >> patternCode [

	^ ruleEditor lhs
]

{ #category : #accessing }
MatchToolPresenter >> patternCode: aPatternCode [

	ruleEditor lhs: aPatternCode
]

{ #category : #actions }
MatchToolPresenter >> performMatching [

	| matches |
	self parsePatternAST.
	self parseCodeAST.
	self emptyLists.
	matches := OrderedCollection new.
	astCode doSemanticAnalysis.
	astCode nodesDo: [ :node | 
		astPattern
			match: node
			onSuccess: [ :bindings | matches add: node -> bindings ]
			onFailure: [  ] ].
	matchesList items: matches
]

{ #category : #accessing }
MatchToolPresenter >> pharoCode [

	^ codeEditor text
]

{ #category : #accessing }
MatchToolPresenter >> pharoCode: aPharoCode [

	codeEditor text: aPharoCode
]

{ #category : #'event handling' }
MatchToolPresenter >> selectedMatchChanged: selection [

	| selectedMatch |
	selectedMatch := selection selectedItem.
	selectedMatch
		ifNil: [ 
			bindingsTable items: #(  ).
			codeEditor clearSelection ]
		ifNotNil: [ 
			bindingsTable items:
				(self getBindingsItemsForMatch: selectedMatch value).
			codeEditor selectionInterval: selectedMatch key sourceInterval ]
]
