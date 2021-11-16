"
I am the panel for the replace with (rhs) part of the rule
"
Class {
	#name : #RTReplaceWithPanel,
	#superclass : #SpPresenter,
	#instVars : [
		'label',
		'codePresenter'
	],
	#category : #'RewriteRuleTools-Widgets'
}

{ #category : #initialization }
RTReplaceWithPanel >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: label expand: false;
		add: codePresenter;
		yourself)
]

{ #category : #initialization }
RTReplaceWithPanel >> initializePresenters [

	label := self newLabel.
	label label: 'Replace with:'.
	
	codePresenter := self newCode.
	codePresenter
		text: DefaultRule new rhs;
		withoutSyntaxHighlight;
		withoutLineNumbers.

	self initializeLayout
]

{ #category : #accessing }
RTReplaceWithPanel >> rhs [

	^ codePresenter text
]

{ #category : #accessing }
RTReplaceWithPanel >> rhs: aString [

	codePresenter text: aString
]
