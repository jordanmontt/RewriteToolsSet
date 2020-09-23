"
I am a simple tool that allows you to load or delete any of the custom rewrite rules that are saved. I open the saved rule on a RewriteBasicEditorPresenter.

To open me: `RewriteRuleLoaderPresenter open`
"
Class {
	#name : #RewriteRuleLoaderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'rulesList',
		'deleteButton',
		'refreshItemsButton',
		'closeButton',
		'openInBasicEditorButton',
		'openInBuilderButton',
		'matchToolButton'
	],
	#category : #'RewriteRuleEditor-Loader'
}

{ #category : #specs }
RewriteRuleLoaderPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #rulesList;
		  add: (SpBoxLayout newHorizontal
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

	| builder |
	builder := RewriteRuleBuilderPresenter new.
	builder sourcePanel code: aRule inputCode.
	builder resultPanel code: aRule outputCode.
	builder transformationRule matchPanel code: aRule lhs.
	builder transformationRule transformPanel code: aRule rhs.
	^ builder openWithSpec
]

{ #category : #accessing }
RewriteRuleLoaderPresenter class >> width [

	^ 700
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
	refreshItemsButton action: [ self refreshRulesListItems ]
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> deleteButtonAction [

	| selectedRuleName |
	rulesList selectedItems ifEmpty: [ 
		self noRuleSelectedAlert.
		^ self ].
	selectedRuleName := rulesList selectedItems first name.
	(UIManager default
		 confirm:
		 'Are you sure you want to delete ' , selectedRuleName , ' rule?'
		 label: 'Delete ' , selectedRuleName , ' ?') ifFalse: [ ^ self ].
	self deleteRule
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> deleteRule [

	| ruleToDelete |
	ruleToDelete := rulesList selectedItems first.
	ruleToDelete removeFromSystem.
	self refreshRulesListItems
]

{ #category : #defaults }
RewriteRuleLoaderPresenter >> getItems [

	^ RBCustomTransformationRule subclasses
]

{ #category : #initialization }
RewriteRuleLoaderPresenter >> initializePresenters [

	rulesList := self newTable.
	rulesList
		items: self getItems;
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
		                           icon: (self iconNamed: #smallDoIt).
	openInBuilderButton := self newButton
		                       label: 'Load on Builder';
		                       icon: (self iconNamed: #smallDoIt).
	matchToolButton := self newButton
		                   label: 'Match rule';
		                   icon: MatchToolPresenter icon.
	deleteButton := self newButton
		                label: 'Delete';
		                icon: (self iconNamed: #smallDelete).
	closeButton := self newButton
		               label: 'Close';
		               icon: (self iconNamed: #smallCancel).
	refreshItemsButton := self newButton
		                      label: 'Refresh items';
		                      icon: (self iconNamed: #smallUpdate).
	self focusOrder
		add: rulesList;
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
		title: 'Rewrite rule loader';
		initialExtent: self class width @ 450;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: 'Loads and deletes custom rewrite rules'
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> loadRuleInBasicEditor [

	| selectedRule |
	rulesList selectedItems ifEmpty: [ 
		self noRuleSelectedAlert.
		^ self ].
	selectedRule := rulesList selectedItems first new.
	^ self class openRuleInBasicEditor: selectedRule
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> loadRuleInBuilder [

	| selectedRule |
	rulesList selectedItems ifEmpty: [ 
		self noRuleSelectedAlert.
		^ self ].
	selectedRule := rulesList selectedItems first new.
	^ self class openRuleInBuilder: selectedRule
]

{ #category : #defaults }
RewriteRuleLoaderPresenter >> noRuleSelectedAlert [
	UIManager default alert: 'You have to select a rule.'
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> openInMatchTool [

	| selectedRule |
	rulesList selectedItems ifEmpty: [ 
		self noRuleSelectedAlert.
		^ self ].
	selectedRule := rulesList selectedItems first new.
	^ MatchToolPresenter new
		  patternCode: selectedRule lhs;
		  pharoCode: selectedRule inputCode;
		  openWithSpec
]

{ #category : #defaults }
RewriteRuleLoaderPresenter >> refreshRulesListItems [

	rulesList items: self getItems
]

{ #category : #accessing }
RewriteRuleLoaderPresenter >> rulesList [
	^ rulesList
]
