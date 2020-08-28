"
This is a tool that allows you to test and match RB matching expressions (Rewrite Rules).
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
		'ruleLabel',
		'codeLabel',
		'methodCheckbox',
		'astPattern',
		'astCode'
	],
	#category : #'RewriteRuleEditor-Matcher'
}

{ #category : #specs }
MatchToolPresenter class >> defaultSpec [

	^ SpBoxLayout newHorizontal
		  add: (SpBoxLayout newVertical
				   add: (SpBoxLayout newHorizontal
						    add: #ruleLabel;
						    add: #methodCheckbox;
						    yourself)
				   expand: false;
				   add: #ruleEditor;
				   add: #codeLabel expand: false;
				   add: #codeEditor;
				   yourself)
		  withConstraints: [ :constraints | 
		  constraints padding: self padding ];
		  add: (SpBoxLayout newVertical
				   add: #executeButton expand: false;
				   add: #matchesList;
				   yourself)
		  withConstraints: [ :constraints | 
			  constraints
				  padding: self padding;
				  width: self width ];
		  add: #bindingsTable withConstraints: [ :constraints | 
		  constraints
			  padding: self padding;
			  width: self width + 50 ];
		  yourself
]

{ #category : #properties }
MatchToolPresenter class >> descriptionText [
	^ 'MatchTool is a simple UI for experimenting with the matching functionality of a rewrite rule'
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
	<example>
	^ self new openWithSpec
]

{ #category : #properties }
MatchToolPresenter class >> padding [
	^ 1
]

{ #category : #properties }
MatchToolPresenter class >> width [
	^ 250
]

{ #category : #defaults }
MatchToolPresenter >> addIconToTheme [
	"This method adds a custom jigsawIcon to the current theme, if absent."
	self theme icons icons
		at: #jigsawIcon
		ifAbsentPut: [ 
		Form fromBinaryStream: self iconContent base64Decoded readStream ]
]

{ #category : #accessing }
MatchToolPresenter >> bindingsTable [

	"This accessor should ONLY be called in the tests. This is for not breaking encapsulation."

	^ bindingsTable
]

{ #category : #accessing }
MatchToolPresenter >> codeEditor [

	"This accessor should ONLY be called in the tests. This is for not breaking encapsulation."

	^ codeEditor
]

{ #category : #initialization }
MatchToolPresenter >> connectPresenters [

	matchesList
		whenSelectionChangedDo: [ :selection | 
			self selectedMatchChanged: selection ];
		whenModelChangedDo: [ :newItems | self matchesChanged ].
	executeButton action: [ self performMatching ]
]

{ #category : #defaults }
MatchToolPresenter >> displayBindingsColumn: association [

	(association value isKindOf: RBProgramNode)
		ifTrue: [ ^ association value formattedCode ]
		ifFalse: [ ^ association value ]
]

{ #category : #defaults }
MatchToolPresenter >> displayPatternColumn: association [

	(association key isKindOf: RBProgramNode)
		ifTrue: [ ^ association key formattedCode ]
		ifFalse: [ ^ association key ]
]

{ #category : #actions }
MatchToolPresenter >> emptyLists [

	bindingsTable items: #(  ).
	matchesList items: #(  )
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

	codeEditor := self newCode.
	ruleEditor := self newCode
		              withoutSyntaxHighlight;
		              yourself.
	methodCheckbox := self newCheckBox
		                  label: 'Method';
		                  yourself.
	codeLabel := self newLabel
		             label: 'Pharo code';
		             yourself.
	ruleLabel := self newLabel
		             label: 'Rewrite rule';
		             yourself.
	executeButton := self newButton
		                 icon: (self iconNamed: #smallDoIt);
		                 label: 'Match';
		                 shortcut: Character cr meta;
		                 yourself.
	matchesList := self newList
		               display: [ :assoc | assoc key formattedCode ];
		               disable;
		               yourself.
	bindingsTable := self newTable
		                 addColumn: (SpStringTableColumn
				                  title: 'Pattern'
				                  evaluated: [ :assoc | 
					                  self displayPatternColumn: assoc ]);
		                 addColumn: (SpStringTableColumn
				                  title: 'Bindings'
				                  evaluated: [ :assoc | 
					                  self displayBindingsColumn: assoc ]);
		                 beResizable;
		                 yourself.
	self focusOrder
		add: ruleLabel;
		add: methodCheckbox;
		add: codeLabel;
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
		initialExtent: 850 @ 450;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #'event handling' }
MatchToolPresenter >> matchesChanged [

	bindingsTable items: #(  ).
	matchesList unselectAll
]

{ #category : #accessing }
MatchToolPresenter >> matchesList [

	"This accessor should ONLY be called in the tests. This is for not breaking encapsulation."

	^ matchesList
]

{ #category : #accessing }
MatchToolPresenter >> methodCheckbox [

	"This accessor should ONLY be called in the tests. This is for not breaking encapsulation."

	^ methodCheckbox
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
		              ifTrue: [ 
		              RBPatternParser parseMethod: ruleEditor text ]
		              ifFalse: [ 
		              RBPatternParser parseExpression: ruleEditor text ]
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
	self updateMatchListItems: matches
]

{ #category : #accessing }
MatchToolPresenter >> ruleEditor [

	"This accessor should ONLY be called in the tests. This is for not breaking encapsulation."

	^ ruleEditor
]

{ #category : #'event handling' }
MatchToolPresenter >> selectedMatchChanged: selection [

	| selectedItem newItems |
	newItems := OrderedCollection new.
	selectedItem := selection selectedItem.
	selectedItem ifNil: [ 
		bindingsTable items: #(  ).
		codeEditor clearSelection.
		^ self ].
	selectedItem value keysAndValuesDo: [ :key :value | 
		(value isKindOf: OrderedCollection)
			ifTrue: [ newItems add: (value collect: [ :each | key -> each ]) ]
			ifFalse: [ newItems add: key -> value ] ].
	bindingsTable items: newItems flattened.
	codeEditor selectionInterval: selectedItem key sourceInterval
]

{ #category : #'event handling' }
MatchToolPresenter >> updateMatchListItems: matches [

	matchesList items: matches
]
