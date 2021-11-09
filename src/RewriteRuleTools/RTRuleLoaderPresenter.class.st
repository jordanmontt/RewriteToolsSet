"
I am a simple tool that allows you to load or delete any of the custom rewrite rules that are saved. I open the saved rule on a RewriteBasicEditorPresenter.

To open me: `RewriteRuleLoaderPresenter open`
"
Class {
	#name : #RTRuleLoaderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'deleteButton',
		'refreshItemsButton',
		'openInBasicEditorButton',
		'openInBuilderButton',
		'matchToolButton',
		'rulesTable',
		'filterTextInput',
		'onlyMyRulesCheckbox'
	],
	#category : #'RewriteRuleTools-Loader'
}

{ #category : #accessing }
RTRuleLoaderPresenter class >> descriptionText [

	^ 'Loads and deletes custom rewrite rules'
]

{ #category : #accessing }
RTRuleLoaderPresenter class >> icon [

	^ self iconNamed: self iconName
]

{ #category : #accessing }
RTRuleLoaderPresenter class >> iconName [

	^ #smallLoadProject
]

{ #category : #defaults }
RTRuleLoaderPresenter class >> instantiateFileAsObject: aFileReference [

	^ aFileReference readStreamDo: [ :stream | STON fromStream: stream ]
]

{ #category : #api }
RTRuleLoaderPresenter class >> open [

	<script>
	^ self new openWithSpec
]

{ #category : #specs }
RTRuleLoaderPresenter class >> openRuleInBasicEditor: aRule [

	^ RTBasicEditorPresenter new
		  lhs: aRule lhs;
		  rhs: aRule rhs;
		  loadedRule: aRule;
		  openWithSpec
]

{ #category : #specs }
RTRuleLoaderPresenter class >> openRuleInBuilder: aRule [

	^ RewriteRuleBuilderPresenter new
		  inputCode: aRule inputCode;
		  outputCode: aRule outputCode;
		  lhs: aRule lhs;
		  rhs: aRule rhs;
		  loadedRule: aRule;
		  openWithSpec
]

{ #category : #accessing }
RTRuleLoaderPresenter class >> title [

	^ 'Rewrite rule loader'
]

{ #category : #actions }
RTRuleLoaderPresenter >> checkboxChanged [

	^ rulesTable items: self getRules
]

{ #category : #initialization }
RTRuleLoaderPresenter >> connectPresenters [

	deleteButton action: [ self deleteButtonAction ].
	refreshItemsButton action: [ self setAllRulesAsTableItems ].
	filterTextInput whenTextChangedDo: [ :aText | self filterRules: aText ].
	onlyMyRulesCheckbox whenChangedDo: [ :state | self checkboxChanged ]
]

{ #category : #actions }
RTRuleLoaderPresenter >> deleteButtonAction [

	rulesTable selectedItems ifEmpty: [ 
		self noRuleIsSelectedAlert.
		^ self ].
	(UIManager default
		confirm: 'Are you sure you want to delete the selected rule?'
		label: 'Delete ') ifFalse: [ ^ self ].
	self deleteRule
]

{ #category : #actions }
RTRuleLoaderPresenter >> deleteRule [

	| ruleToDelete |
	ruleToDelete := rulesTable selectedItems first.
	ruleToDelete delete.
	self setAllRulesAsTableItems
]

{ #category : #actions }
RTRuleLoaderPresenter >> filterRules: aText [

	| filteredRules |
	filteredRules := self getRules select: [ :each | 
		each basenameWithoutExtension asLowercase includesSubstring: aText asLowercase ].
	rulesTable items: filteredRules
]

{ #category : #accessing }
RTRuleLoaderPresenter >> getRules [

	^ onlyMyRulesCheckbox state
		  ifTrue: [ RTRuleSaver customRulesAsFileReference ]
		  ifFalse: [ RTRuleSaver allRulesAsFileReference ]
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializeButtons [

	openInBasicEditorButton := self instantiate: (OpenRTBasicEditorCommand asSpecButtonForContext: self).
	openInBuilderButton := self instantiate: (OpenRTRuleBuilderCommand asSpecButtonForContext: self).
	matchToolButton := self instantiate: (OpenMatchToolCommand asSpecButtonForContext: self).

	deleteButton := self newButton.
	deleteButton
		label: 'Delete';
		icon: (self iconNamed: #smallDelete).

	refreshItemsButton := self newButton.
	refreshItemsButton
		label: 'Refresh';
		icon: (self iconNamed: #smallUpdate)
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: rulesTable;
		add: filterTextInput expand: false;
		add: (SpBoxLayout newLeftToRight
			add: onlyMyRulesCheckbox;
			add: openInBasicEditorButton;
			add: openInBuilderButton;
			add: matchToolButton;
			add: deleteButton;
			add: refreshItemsButton;
			yourself)
		expand: false;
		yourself)
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializePresenters [

	onlyMyRulesCheckbox := self newCheckBox.
	onlyMyRulesCheckbox label: 'Only custom rules'.
	self initializeTable.
	self initializeButtons.
	self initializeLayout
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializeTable [

	| hashTagTableColumn ruleNameTableColumn lhsTableColumn rhsTableColumn |
	rulesTable := self newTable.
	hashTagTableColumn := (SpIndexTableColumn title: '#')
		width: 20;
		yourself.
	ruleNameTableColumn := SpStringTableColumn
		title: 'Rule name'
		evaluated: [ :f | (self class instantiateFileAsObject: f) name ].
	lhsTableColumn := SpStringTableColumn
		title: 'Search for'
		evaluated: [ :f | (self class instantiateFileAsObject: f) lhs ].
	rhsTableColumn := SpStringTableColumn
		title: 'Replace with'
		evaluated: [ :f | (self class instantiateFileAsObject: f) rhs ].
	rulesTable
		items: self getRules;
		sortingBlock: [ :a :b | a basenameWithoutExtension < b basenameWithoutExtension ];
		addColumn: hashTagTableColumn;
		addColumn: ruleNameTableColumn;
		addColumn: lhsTableColumn;
		addColumn: rhsTableColumn.
	

	filterTextInput := self newTextInput
		placeholder: 'Filter...';
		yourself
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 700 @ 450;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #accessing }
RTRuleLoaderPresenter >> lhs [

	^ rulesTable selectedItem
		ifNil: [ '' ]
		ifNotNil: [ :f | (self class instantiateFileAsObject: f) lhs ]
]

{ #category : #alerts }
RTRuleLoaderPresenter >> noRuleIsSelectedAlert [

	UIManager default alert: 'You have to select a rule.'
]

{ #category : #accessing }
RTRuleLoaderPresenter >> rhs [

	^ rulesTable selectedItem
		ifNil: [ '' ]
		ifNotNil: [ :f | (self class instantiateFileAsObject: f) rhs ]
]

{ #category : #actions }
RTRuleLoaderPresenter >> setAllRulesAsTableItems [

	rulesTable items: self getRules.
	onlyMyRulesCheckbox state: false
]
