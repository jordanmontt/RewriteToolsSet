Class {
	#name : #SaveRuleCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
SaveRuleCommand class >> defaultName [

	^ 'Save rule'
]

{ #category : #default }
SaveRuleCommand class >> iconName [

	^ #smallSaveAs
]

{ #category : #executing }
SaveRuleCommand >> execute [

	| ruleHolder |
	ruleHolder := RTRuleHolder
		lhs: self context lhs
		rhs: self context rhs
		isForMethod: self context isRuleForMethod.
	RTRuleSaver storeRuleOnDisk: ruleHolder
]
