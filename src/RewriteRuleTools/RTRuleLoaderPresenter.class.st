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
		'closeButton',
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

	^ self iconNamed: #smallLoadProject
]

{ #category : #api }
RTRuleLoaderPresenter class >> open [

	<script>
	^ self new openWithSpec
]

{ #category : #specs }
RTRuleLoaderPresenter class >> openRuleInBasicEditor: aRule [

	^ RTBasicEditorPresenter new
		  searchForPatternCode: aRule lhs;
		  replaceWithPatternCode: aRule rhs;
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

{ #category : #actions }
RTRuleLoaderPresenter >> close [
	self window close
]

{ #category : #initialization }
RTRuleLoaderPresenter >> connectPresenters [

	openInBasicEditorButton action: [ self loadRuleInBasicEditor ].
	openInBuilderButton action: [ self loadRuleInBuilder ].
	matchToolButton action: [ self openInMatchTool ].
	deleteButton action: [ self deleteButtonAction ].
	closeButton action: [ self close ].
	refreshItemsButton action: [ self setAllRulesAsTableItems ].
	filterTextInput whenTextChangedDo: [ :aText | 
		self filterRules: aText ].
	onlyMyRulesCheckbox whenChangedDo: [ :state | self checkboxChanged ]
]

{ #category : #actions }
RTRuleLoaderPresenter >> deleteButtonAction [

	| selectedRuleName |
	rulesTable selectedItems ifEmpty: [ 
		self noRuleIsSelectedAlert.
		^ self ].
	selectedRuleName := rulesTable selectedItems first name.
	(UIManager default
		 confirm:
		 'Are you sure you want to delete ' , selectedRuleName , ' rule?'
		 label: 'Delete ' , selectedRuleName , ' ?') ifFalse: [ ^ self ].
	self deleteRule
]

{ #category : #actions }
RTRuleLoaderPresenter >> deleteRule [

	| ruleToDelete |
	ruleToDelete := rulesTable selectedItems first.
	ruleToDelete removeFromSystem.
	self setAllRulesAsTableItems
]

{ #category : #actions }
RTRuleLoaderPresenter >> filterRules: aText [

	| filteredRules |
	filteredRules := self getRules select: [ :each | 
		                 each name asLowercase includesSubstring:
			                 aText asLowercase ].
	rulesTable items: filteredRules
]

{ #category : #accessing }
RTRuleLoaderPresenter >> getRules [

	^ onlyMyRulesCheckbox state
		  ifTrue: [ RTCustomRuleGenerator getOnlyCustomRules ]
		  ifFalse: [ RTCustomRuleGenerator getAllRules ]
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: #rulesTable;
			 add: #filterTextInput expand: false;
			 add: (SpBoxLayout newLeftToRight
					  add: #onlyMyRulesCheckbox;
					  add: #openInBasicEditorButton;
					  add: #openInBuilderButton;
					  add: #matchToolButton;
					  add: #deleteButton;
					  add: #refreshItemsButton;
					  add: #closeButton;
					  yourself)
			 expand: false;
			 yourself)
]

{ #category : #initialization }
RTRuleLoaderPresenter >> initializePresenters [

	self initializeLayout.
	onlyMyRulesCheckbox := self newCheckBox label: 'Only custom rules'.
	rulesTable := self newTable.
	rulesTable
		items: RTCustomRuleGenerator getAllRules;
		sortingBlock: [ :a :b | a name < b name ];
		addColumn: ((SpIndexTableColumn title: '#')
				 width: 20;
				 yourself);
		addColumn: (SpStringTableColumn title: 'Rule name' evaluated: #name);
		addColumn:
		(SpStringTableColumn
			 title: 'Search for'
			 evaluated: [ :e | e new lhs ]);
		addColumn: (SpStringTableColumn
				 title: 'Replace with'
				 evaluated: [ :e | e new rhs ]).
	openInBasicEditorButton := self newButton
		                           label: 'Load';
		                           icon: (self iconNamed: #smallDoIt);
		                           yourself.
	openInBuilderButton := self newButton
		                       label: 'Load on Builder';
		                       icon: (self iconNamed: #smallDoIt);
		                       yourself.
	matchToolButton := self newButton
		                   label: 'Match rule';
		                   icon: MatchToolPresenter icon;
		                   yourself.
	deleteButton := self newButton
		                label: 'Delete';
		                icon: (self iconNamed: #smallDelete).
	closeButton := self newButton
		               label: 'Close';
		               icon: (self iconNamed: #smallCancel);
		               yourself.
	refreshItemsButton := self newButton
		                      label: 'Refresh';
		                      icon: (self iconNamed: #smallUpdate);
		                      yourself.
	filterTextInput := self newTextInput
		                   placeholder: 'Filter...';
		                   yourself.
	self focusOrder
		add: rulesTable;
		add: onlyMyRulesCheckbox;
		add: openInBasicEditorButton;
		add: openInBuilderButton;
		add: matchToolButton;
		add: deleteButton;
		add: refreshItemsButton;
		add: closeButton
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

{ #category : #actions }
RTRuleLoaderPresenter >> loadRuleInBasicEditor [

	| selectedRule |
	rulesTable selectedItems ifEmpty: [ 
		self noRuleIsSelectedAlert.
		^ self ].
	selectedRule := rulesTable selectedItems first new.
	^ self class openRuleInBasicEditor: selectedRule
]

{ #category : #actions }
RTRuleLoaderPresenter >> loadRuleInBuilder [

	| selectedRule |
	rulesTable selectedItems ifEmpty: [ 
		self noRuleIsSelectedAlert.
		^ self ].
	selectedRule := rulesTable selectedItems first new.
	^ self class openRuleInBuilder: selectedRule
]

{ #category : #alerts }
RTRuleLoaderPresenter >> noRuleIsSelectedAlert [

	UIManager default alert: 'You have to select a rule.'
]

{ #category : #accessing }
RTRuleLoaderPresenter >> onlyMyRulesCheckbox [

	^ onlyMyRulesCheckbox
]

{ #category : #actions }
RTRuleLoaderPresenter >> openInMatchTool [

	| selectedRule |
	rulesTable selectedItems ifEmpty: [ 
		self noRuleIsSelectedAlert.
		^ self ].
	selectedRule := rulesTable selectedItems first new.
	^ MatchToolPresenter new
		  patternCode: selectedRule lhs;
		  pharoCode: selectedRule inputCode;
		  openWithSpec
]

{ #category : #accessing }
RTRuleLoaderPresenter >> rulesTable [
	^ rulesTable
]

{ #category : #actions }
RTRuleLoaderPresenter >> setAllRulesAsTableItems [

	rulesTable items: RTCustomRuleGenerator getAllRules.
	onlyMyRulesCheckbox state: false
]
