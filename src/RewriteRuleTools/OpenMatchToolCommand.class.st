"
I am a command that opens match tool presenter from another presenter keeping the same code.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #OpenMatchToolCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenMatchToolCommand class >> defaultDescription [

	^ 'Open MatchTool'
]

{ #category : #default }
OpenMatchToolCommand class >> defaultName [

	^ 'Match rule'
]

{ #category : #default }
OpenMatchToolCommand class >> iconName [

	^ MatchToolPresenter iconName
]

{ #category : #executing }
OpenMatchToolCommand >> execute [

	^ MatchToolPresenter new
		patternCode: self context lhs;
		pharoCode: '';
		openWithSpec
]
