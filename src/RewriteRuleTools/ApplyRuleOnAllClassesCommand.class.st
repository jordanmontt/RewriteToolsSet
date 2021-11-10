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

	^ 'Apply on all classes'
]

{ #category : #default }
ApplyRuleOnAllClassesCommand class >> iconName [

	^ RTRuleApplierPresenter iconName
]

{ #category : #executing }
ApplyRuleOnAllClassesCommand >> execute [

	| changes |
	(UIManager default confirm:
		 'Do you want to apply this rule to all system classes?') ifFalse: [ ^ self ].
	changes := RTApplier
		changesForAssociation: self context lhs -> self context rhs
		isForMethod: self context isRuleForMethod.
	^ (RTChangesBrowser changes: changes) open
]
