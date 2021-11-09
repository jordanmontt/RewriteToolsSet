Class {
	#name : #OpenMatchToolCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

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
