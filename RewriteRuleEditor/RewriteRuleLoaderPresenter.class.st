"
A simple GUI that permits to load a custom rule into RewriteBasicEditorPresenter.
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

{ #category : #actions }
RewriteRuleLoaderPresenter >> close [
	self window close
]

{ #category : #initialization }
RewriteRuleLoaderPresenter >> connectPresenters [

	loadButton action: [ 
		self loadRule.
		self close ].
	deleteButton action: [ 
		self deleteRule.
		self refreshItems ].
	closeButton action: [ self close ]
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> deleteRule [

	| ruleToDelete |
	rulesList selectedItems ifEmpty: [ 
		self noRuleSelectedAlert.
		^ self ].
	(UIManager default confirm:
		 'Are you sure you want to delete the selected rule?') ifFalse: [ 
		^ self ].
	ruleToDelete := rulesList selectedItems first.
	ruleToDelete removeFromSystem
]

{ #category : #initialization }
RewriteRuleLoaderPresenter >> initializePresenters [

	rulesList := self newList
		             items: RBCustomTransformationRule subclasses;
		             yourself.
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
		             yourself
]

{ #category : #initialization }
RewriteRuleLoaderPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Rewrite rule loader';
		initialExtent: 300 @ 300;
		windowIcon: (self class icon);
		askOkToClose: false;
		aboutText: 'Opens BasicTransformationPresenter with a custom rule'
]

{ #category : #actions }
RewriteRuleLoaderPresenter >> loadRule [

	| selectedRule |
	rulesList selectedItems ifEmpty: [ 
		self noRuleSelectedAlert.
		^ self ].
	selectedRule := rulesList selectedItems first new.
	^ RewriteBasicEditorPresenter new
		  searchForPatternCode: selectedRule searchFor;
		  replaceWithPatternCode: selectedRule replaceWith;
		ruleName: selectedRule className;
		  openWithSpec
]

{ #category : #defaults }
RewriteRuleLoaderPresenter >> noRuleSelectedAlert [
	UIManager default alert: 'You have to select a rule.'
]

{ #category : #defaults }
RewriteRuleLoaderPresenter >> refreshItems [

	rulesList items: RBCustomTransformationRule subclasses
]

{ #category : #accessing }
RewriteRuleLoaderPresenter >> rulesList [
	^ rulesList
]
