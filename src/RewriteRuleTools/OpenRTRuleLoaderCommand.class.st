Class {
	#name : #OpenRTRuleLoaderCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTRuleLoaderCommand class >> defaultName [

	^ 'Load a rule'
]

{ #category : #default }
OpenRTRuleLoaderCommand class >> iconName [

	^ RTRuleApplierPresenter iconName
]

{ #category : #executing }
OpenRTRuleLoaderCommand >> execute [

	^ RTRuleLoaderPresenter open
]
