Class {
	#name : #OpenRTHelpBrowserCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

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

	^ RTRulesHelpPresenter open
]
