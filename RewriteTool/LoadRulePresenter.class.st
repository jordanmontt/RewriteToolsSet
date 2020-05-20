"
A simple UI to load a custom rule into BasicTransformationPresenter presenter.
"
Class {
	#name : #LoadRulePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'rulesList',
		'buttonsBar'
	],
	#category : #'RewriteTool-BasicTransformation'
}

{ #category : #specs }
LoadRulePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #rulesList;
		add: #buttonsBar height: 40;
		yourself
]

{ #category : #'instance creation' }
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
	buttonsBar := self newButtonBar
		add:
			(self newButton
				label: 'Load rule';
				icon: (self iconNamed: #smallDoIt);
				action: [ self loadRule.
					self close ]);
		add:
			(self newButton
				label: 'Cancel';
				icon: (self iconNamed: #smallCancel);
				action: [ self close ]);
		yourself
]

{ #category : #initialization }
LoadRulePresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Rewrite rule loader';
		initialExtent: 300 @ 300;
		windowIcon: (self iconNamed: #taskbarIcon);
		askOkToClose: false;
		aboutText: 'Opens BasicTransformationPresenter with a custom rule'
]

{ #category : #actions }
LoadRulePresenter >> loadRule [
	| selectedRule |
	selectedRule := rulesList selectedItems first new.
	selectedRule ifNil: [ ^ self ].
	BasicTransformationPresenter new
		searchForCode: selectedRule searchFor;
		replaceWithCode: selectedRule replaceWith;
		openWithSpec
]
