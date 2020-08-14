"
A simple GUI that permits to load a custom rule into RewriteBasicEditorPresenter.
"
Class {
	#name : #LoadRewriteRulePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'rulesList',
		'buttonBar'
	],
	#category : #'RewriteRuleEditor-BasicEditor'
}

{ #category : #specs }
LoadRewriteRulePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #rulesList;
		addLast: #buttonBar;
		yourself
]

{ #category : #accessing }
LoadRewriteRulePresenter class >> icon [ 
	^ self iconNamed: #smallFind
]

{ #category : #api }
LoadRewriteRulePresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #actions }
LoadRewriteRulePresenter >> close [
	self window close
]

{ #category : #actions }
LoadRewriteRulePresenter >> deleteRule [

	| ruleToDelete confirmationAnswer |
	rulesList selectedItems ifEmpty: [ 
		self noRuleSelectedAlert.
		^ self ].
	confirmationAnswer := UIManager default confirm:
		                      'Are you sure you want to delete the selected rule?'.
	confirmationAnswer ifFalse: [ ^ self ].
	ruleToDelete := rulesList selectedItems first.
	ruleToDelete removeFromSystem
]

{ #category : #initialization }
LoadRewriteRulePresenter >> initializePresenters [

	rulesList := self newList
		             items: RBCustomTransformationRule subclasses;
		             yourself.
	buttonBar := self newActionBar
		             add: (self newButton
				              label: 'Load';
				              icon: (self iconNamed: #smallDoIt);
				              action: [ 
					              self loadRule.
					              self close ]);
		             add: (self newButton
				              label: 'Delete';
				              icon: (self iconNamed: #smallDelete);
				              action: [ 
					              self deleteRule.
					              self refreshItems ]);
		             add: (self newButton
				              label: 'Close';
				              icon: (self iconNamed: #smallCancel);
				              action: [ self close ]);
		             yourself
]

{ #category : #initialization }
LoadRewriteRulePresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Rewrite rule loader';
		initialExtent: 300 @ 300;
		windowIcon: (self class icon);
		askOkToClose: false;
		aboutText: 'Opens BasicTransformationPresenter with a custom rule'
]

{ #category : #actions }
LoadRewriteRulePresenter >> loadRule [

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
LoadRewriteRulePresenter >> noRuleSelectedAlert [
	UIManager default alert: 'You have to select a rule.'
]

{ #category : #defaults }
LoadRewriteRulePresenter >> refreshItems [

	rulesList items: RBCustomTransformationRule subclasses
]

{ #category : #accessing }
LoadRewriteRulePresenter >> rulesList [
	^ rulesList
]
