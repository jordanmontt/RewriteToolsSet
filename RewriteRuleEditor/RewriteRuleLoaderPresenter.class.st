"
I am a simple tool that allows you to load or delete any of the custom rewrite rules that are saved. I open the saved rule on a RewriteBasicEditorPresenter.

To open me: `RewriteRuleLoaderPresenter open`
"
Class {
	#name : #RewriteRuleLoaderPresenter,
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
	#category : #'RewriteRuleEditor-Loader'
}

{ #category : #specs }
RewriteRuleLoaderPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #rulesTable;
		  add: #filterTextInput expand: false;
		  add: (SpBoxLayout newHorizontal
				   add: #onlyMyRulesCheckbox;
				   add: #openInBasicEditorButton;
				   add: #openInBuilderButton;
				   add: #matchToolButton;
				   add: #deleteButton;
				   add: #refreshItemsButton;
				   add: #closeButton;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : #accessing }
RewriteRuleLoaderPresenter class >> descriptionText [

	^ 'Loads and deletes custom rewrite rules'
]

{ #category : #accessing }
RewriteRuleLoaderPresenter class >> icon [ 
	^ self iconNamed: #smallFind
]

{ #category : #api }
RewriteRuleLoaderPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #specs }
RewriteRuleLoaderPresenter class >> openRuleInBasicEditor: aRule [

	^ RewriteBasicEditorPresenter new
		  searchForPatternCode: aRule lhs;
		  replaceWithPatternCode: aRule rhs;
		  ruleName: aRule className;
		  openWithSpec
]

{ #category : #specs }
RewriteRuleLoaderPresenter class >> openRuleInBuilder: aRule [

	^ RewriteRuleBuilderPresenter new
		  inputCode: aRule inputCode;
		  outputCode: aRule outputCode;
		  lhs: aRule lhs;
		  rhs: aRule rhs;
		  ruleName: aRule className;
		  openWithSpec
]

{ #category : #accessing }
RewriteRuleLoaderPresenter class >> title [

	^ 'Rewrite rule loader'
]

{ #category : #accessing }
RewriteRuleLoaderPresenter class >> width [

	^ 700
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> checkboxChanged [

	^ rulesTable items: self getRules
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> close [
	self window close
]

{ #category : #initialization }
RewriteRuleLoaderPresenter >> connectPresenters [

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
RewriteRuleLoaderPresenter >> deleteButtonAction [

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
RewriteRuleLoaderPresenter >> deleteRule [

	| ruleToDelete |
	ruleToDelete := rulesTable selectedItems first.
	ruleToDelete removeFromSystem.
	self setAllRulesAsTableItems
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> filterRules: aText [

	| filteredRules |
	filteredRules := self getRules select: [ :each | 
		                 each name asLowercase includesSubstring:
			                 aText asLowercase ].
	rulesTable items: filteredRules
]

{ #category : #accessing }
RewriteRuleLoaderPresenter >> getRules [

	^ onlyMyRulesCheckbox state
		  ifTrue: [ CustomRuleGenerator getOnlyCustomRules ]
		  ifFalse: [ CustomRuleGenerator getAllRules ]
]

{ #category : #initialization }
RewriteRuleLoaderPresenter >> initializePresenters [

	onlyMyRulesCheckbox := self newCheckBox label: 'Only custom rules'.
	rulesTable := self newTable.
	rulesTable
		items: CustomRuleGenerator getAllRules;
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
RewriteRuleLoaderPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: self class width @ 450;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> loadRuleInBasicEditor [

	| selectedRule |
	rulesTable selectedItems ifEmpty: [ 
		self noRuleIsSelectedAlert.
		^ self ].
	selectedRule := rulesTable selectedItems first new.
	^ self class openRuleInBasicEditor: selectedRule
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> loadRuleInBuilder [

	| selectedRule |
	rulesTable selectedItems ifEmpty: [ 
		self noRuleIsSelectedAlert.
		^ self ].
	selectedRule := rulesTable selectedItems first new.
	^ self class openRuleInBuilder: selectedRule
]

{ #category : #alerts }
RewriteRuleLoaderPresenter >> noRuleIsSelectedAlert [

	UIManager default alert: 'You have to select a rule.'
]

{ #category : #accessing }
RewriteRuleLoaderPresenter >> onlyMyRulesCheckbox [

	^ onlyMyRulesCheckbox
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> openInMatchTool [

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
RewriteRuleLoaderPresenter >> rulesTable [
	^ rulesTable
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> setAllRulesAsTableItems [

	rulesTable items: CustomRuleGenerator getAllRules.
	onlyMyRulesCheckbox state: false
]
