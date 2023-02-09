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

{ #category : #layout }
RTReplaceWithPanel >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: label expand: false;
		  add: codePresenter;
		  yourself
]

{ #category : #initialization }
RTReplaceWithPanel >> initializePresenters [

	label := self newLabel.
	label label: 'Replace with:'.

	codePresenter := self newCode.
	codePresenter
		text: RTDemoRules defaultRule rhs;
		withoutSyntaxHighlight;
		withoutLineNumbers
]

{ #category : #accessing }
RTReplaceWithPanel >> rhs [

	^ codePresenter text
]

{ #category : #accessing }
RTReplaceWithPanel >> rhs: aString [

	codePresenter text: aString
]
