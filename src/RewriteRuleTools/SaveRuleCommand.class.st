"
I am a command that saves a rewrite rule to the system as a ston file.

I can be converted into a sepc button to be used in a presenter
"
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
