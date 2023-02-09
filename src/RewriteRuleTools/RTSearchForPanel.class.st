"
I am the panel for the search for (lhs) part of the rule
"
Class {
	#name : #RTSearchForPanel,
	#superclass : #SpPresenter,
	#instVars : [
		'label',
		'codePresenter'
	],
	#category : #'RewriteRuleTools-Widgets'
}

{ #category : #layout }
RTSearchForPanel >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: label expand: false;
		add: codePresenter;
		yourself
]

{ #category : #initialization }
RTSearchForPanel >> initializePresenters [

	label := self newLabel.
	label label: 'Search for:'.

	codePresenter := self newCode.
	codePresenter
		text: RTDemoRules defaultRule lhs;
		withoutSyntaxHighlight;
		withoutLineNumbers
]

{ #category : #accessing }
RTSearchForPanel >> lhs [

	^ codePresenter text
]

{ #category : #accessing }
RTSearchForPanel >> lhs: aString [

	codePresenter text: aString
]
