"
I am a command that applies the rule that is already present on the presenter to all system classes.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #ApplyRuleOnAllClassesCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
ApplyRuleOnAllClassesCommand class >> defaultDescription [

	^ 'Apply the current rewrite rule that is on this tool to all classes in the system.'
]

{ #category : #default }
ApplyRuleOnAllClassesCommand class >> defaultName [

	^ 'Transform all classes'
]

{ #category : #default }
ApplyRuleOnAllClassesCommand class >> iconName [

	^ ScopeSelectorPresenter iconName
]

{ #category : #executing }
ApplyRuleOnAllClassesCommand >> execute [

	| changes ruleHolder |
	(UIManager default
		confirm: 'This process can take between 1 and 2 minutes.'
		label: 'Proceed?')
	ifFalse: [ ^ self ].
	ruleHolder := RTAbstractApplier
		createRuleHolder: self context lhs -> self context rhs
		isforMethod: self context isRuleForMethod.

	changes := RTAbstractApplier defaultEngineApplier
		calculateAllChangesForRules: ruleHolder asOrderedCollection.
	^ (ChangesBrowser changes: changes) open
]
