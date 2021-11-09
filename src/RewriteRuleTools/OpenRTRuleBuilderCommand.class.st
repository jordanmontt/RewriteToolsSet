Class {
	#name : #OpenRTRuleBuilderCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
OpenRTRuleBuilderCommand class >> defaultName [

	^ 'Build rule'
]

{ #category : #default }
OpenRTRuleBuilderCommand class >> iconName [

	^ RewriteRuleBuilderPresenter iconName
]

{ #category : #executing }
OpenRTRuleBuilderCommand >> execute [

	^ RewriteRuleBuilderPresenter new
		lhs: self context lhs;
		rhs: self context rhs;
		inputCode: '';
		outputCode: '';
		openWithSpec
]
