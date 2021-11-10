"
I am a command that open the expression finder presenter from another presenter keeping the same code.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #OpenRTExpressionFinderCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTExpressionFinderCommand class >> defaultName [

	^ 'Find'
]

{ #category : #default }
OpenRTExpressionFinderCommand class >> iconName [

	^ RTExpressionFinderPresenter iconName
]

{ #category : #executing }
OpenRTExpressionFinderCommand >> execute [

	^ RTExpressionFinderPresenter new
		patternCode: self context lhs;
		openWithSpec
]
