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
OpenRTExpressionFinderCommand class >> defaultDescription [

	^ 'Find ocurrences of an expression in all Pharo''s code'
]

{ #category : #default }
OpenRTExpressionFinderCommand class >> defaultName [

	^ 'Find occurrences'
]

{ #category : #default }
OpenRTExpressionFinderCommand class >> iconName [

	^ RTExpressionFinderPresenter iconName
]

{ #category : #executing }
OpenRTExpressionFinderCommand >> execute [

	| window |
	window := RTApplication new startExpressionFinder.
	window presenter patternCode: self context lhs.
	^ window
]
