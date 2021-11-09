Class {
	#name : #OpenRTBasicEditorCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTBasicEditorCommand class >> defaultName [

	^ 'Rule editor'
]

{ #category : #default }
OpenRTBasicEditorCommand class >> iconName [

	^RTBasicEditorPresenter iconName
]

{ #category : #executing }
OpenRTBasicEditorCommand >> execute [

	^ RTBasicEditorPresenter new
		lhs: self context lhs;
		rhs: self context rhs;
		openWithSpec
]
