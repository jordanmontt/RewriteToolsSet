"
I am a command that applies the rule that is already present on the presenter to a seleted set of classes.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #ApplyRuleOnSelectedClassesCommand,
	#superclass : #CmCommand,
	#category : #'RewriteRuleTools-Commands'
}

{ #category : #default }
ApplyRuleOnSelectedClassesCommand class >> defaultDescription [

	^ 'Apply the current rewrite rule that is on this tool a selected scope.'
]

{ #category : #default }
ApplyRuleOnSelectedClassesCommand class >> defaultName [

	^ 'Transform selected classes'
]

{ #category : #accessing }
ApplyRuleOnSelectedClassesCommand class >> iconName [

	^ RTCodeTransformerPresenter iconName
]

{ #category : #executing }
ApplyRuleOnSelectedClassesCommand >> execute [

	| dialogWindow changes |
	dialogWindow := self context scopeSelectorPresenter openAsDialog.
	dialogWindow
		okAction: [
			changes := RTAbstractApplier defaultEngineApplier
				changesToClasses: self context scopeSelectorPresenter selectedClasses
				association: self context lhs -> self context rhs
				isForMethod: self context isRuleForMethod.
			(RTChangesBrowser changes: changes) open ].
	
	
]
