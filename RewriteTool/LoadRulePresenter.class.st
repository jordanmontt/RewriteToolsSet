"
A simple GUI that permits to load a custom rule into RewriteBasicEditorPresenter.
"
Class {
	#name : #LoadRulePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'rulesList',
		'buttonBar'
	],
	#category : #'RewriteTool-BasicEditor'
}

{ #category : #specs }
LoadRulePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #rulesList;
		add: #buttonBar height: 40;
		yourself
]

{ #category : #accessing }
LoadRulePresenter class >> icon [ 
	^ self iconNamed: #smallFind
]

{ #category : #api }
LoadRulePresenter class >> open [
	<script>
	^ self new openWithSpec
]

{ #category : #actions }
LoadRulePresenter >> close [
	self window close
]

{ #category : #initialization }
LoadRulePresenter >> initializePresenters [
	rulesList := self newList
		items:
			(RBCustomTransformationRule subclasses collect: [ :each | each ])
				asOrderedCollection;
		yourself.
	buttonBar := self newActionBar
		add:
			(self newButton
				label: 'Load';
				icon: (self iconNamed: #smallDoIt);
				action: [ self loadRule.
					self close ]);
		add:
			(self newButton
				label: 'Close';
				icon: (self iconNamed: #smallCancel);
				action: [ self close ]);
		yourself
]

{ #category : #initialization }
LoadRulePresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Rewrite rule loader';
		initialExtent: 300 @ 300;
		windowIcon: (self class icon);
		askOkToClose: false;
		aboutText: 'Opens BasicTransformationPresenter with a custom rule'
]

{ #category : #actions }
LoadRulePresenter >> loadRule [
	| selectedRule |
	selectedRule := rulesList selectedItems first new.
	selectedRule ifNil: [ ^ self ].
	RewriteBasicEditorPresenter new
		searchForCode: selectedRule searchFor;
		replaceWithCode: selectedRule replaceWith;
		openWithSpec
]
