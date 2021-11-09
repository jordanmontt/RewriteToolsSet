Class {
	#name : #OpenRTExpressionFinderCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTExpressionFinderCommand class >> defaultName [

	^ 'Expression finder'
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
