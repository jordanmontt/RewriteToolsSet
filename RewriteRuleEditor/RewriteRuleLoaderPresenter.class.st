"
I am a simple tool that allows you to load or delete any of the custom rewrite rules that are saved. I open the saved rule on a RewriteBasicEditorPresenter.

To open me: `RewriteRuleLoaderPresenter open`
"
Class {
	#name : #RewriteRuleLoaderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'rulesList',
		'buttonBar',
		'loadButton',
		'deleteButton',
		'closeButton'
	],
	#category : #'RewriteRuleEditor-Loader'
}

{ #category : #specs }
RewriteRuleLoaderPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #rulesList;
		addLast: #buttonBar;
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
		  searchForPatternCode: aRule searchFor;
		  replaceWithPatternCode: aRule replaceWith;
		  ruleName: aRule className;
		  openWithSpec
]

{ #category : #accessing }
RewriteRuleLoaderPresenter class >> width [

	^ 650
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> close [
	self window close
]

{ #category : #initialization }
RewriteRuleLoaderPresenter >> connectPresenters [

	loadButton action: [ 
		self loadRule.
		self close ].
	deleteButton action: [ self deleteButtonAction ].
	closeButton action: [ self close ]
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> deleteButtonAction [

	rulesList selectedItems ifEmpty: [ 
		self noRuleSelectedAlert.
		^ self ].
	(UIManager default confirm:
		 'Are you sure you want to delete the selected rule?') ifFalse: [ 
		^ self ].
	self deleteRule
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> deleteRule [

	| ruleToDelete |
	ruleToDelete := rulesList selectedItems first.
	ruleToDelete removeFromSystem.
	self refreshRulesListItems
]

{ #category : #initialization }
RewriteRuleLoaderPresenter >> initializePresenters [

	| ruleMaxSize |
	ruleMaxSize := (self class width / 19) asInteger.
	rulesList := self newTable.
	rulesList
		items: RBTransformationRule subclasses;
		addColumn: (SpStringTableColumn title: 'Rule name' evaluated: #name);
		addColumn:
			(SpStringTableColumn title: 'Search for' evaluated: [ :e | 
					 e new searchFor size > ruleMaxSize
						 ifTrue: [ (e new searchFor first: ruleMaxSize) , '...' ]
						 ifFalse: [ e new searchFor ] ]);
		addColumn:
			(SpStringTableColumn title: 'Replace with' evaluated: [ :e | 
					 e new replaceWith size > ruleMaxSize
						 ifTrue: [ (e new replaceWith first: ruleMaxSize) , '...' ]
						 ifFalse: [ e new replaceWith ] ]).
	loadButton := self newButton
		              label: 'Load';
		              icon: (self iconNamed: #smallDoIt).
	deleteButton := self newButton
		                label: 'Delete';
		                icon: (self iconNamed: #smallDelete).
	closeButton := self newButton
		               label: 'Close';
		               icon: (self iconNamed: #smallCancel).
	buttonBar := self newActionBar
		             add: loadButton;
		             add: deleteButton;
		             add: closeButton;
		             yourself.
	self focusOrder
		add: rulesList;
		add: buttonBar
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
RewriteRuleLoaderPresenter >> loadRule [

	| selectedRule |
	rulesList selectedItems ifEmpty: [ 
		self noRuleSelectedAlert.
		^ self ].
	selectedRule := rulesList selectedItems first new.
	^ self class openRuleInBasicEditor: selectedRule
]

{ #category : #defaults }
RewriteRuleLoaderPresenter >> noRuleSelectedAlert [
	UIManager default alert: 'You have to select a rule.'
]

{ #category : #defaults }
RewriteRuleLoaderPresenter >> refreshRulesListItems [

	rulesList items: RBTransformationRule subclasses
]

{ #category : #accessing }
RewriteRuleLoaderPresenter >> rulesList [
	^ rulesList
]
