"
I open the RT help browser presenter.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #OpenRTHelpBrowserCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTHelpBrowserCommand class >> defaultDescription [

	^ 'Help browser'
]

{ #category : #default }
OpenRTHelpBrowserCommand class >> defaultName [

	^ 'More help'
]

{ #category : #default }
OpenRTHelpBrowserCommand class >> iconName [

	^#smallQuestionIcon
]

{ #category : #executing }
OpenRTHelpBrowserCommand >> execute [

	^ RTHelpBrowserPresenter open
]
