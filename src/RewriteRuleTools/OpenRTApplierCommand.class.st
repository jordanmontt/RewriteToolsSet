Class {
	#name : #OpenRTApplierCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTApplierCommand class >> defaultDescription [

	^ 'Open a tool to apply a saved rewrite rule to a selected set of classes.'
]

{ #category : #default }
OpenRTApplierCommand class >> defaultName [

	^ 'Apply on selection...'
]

{ #category : #default }
OpenRTApplierCommand class >> iconName [

	^ RTRuleApplierPresenter iconName
]

{ #category : #executing }
OpenRTApplierCommand >> execute [

	^ RTRuleApplierPresenter open
]
