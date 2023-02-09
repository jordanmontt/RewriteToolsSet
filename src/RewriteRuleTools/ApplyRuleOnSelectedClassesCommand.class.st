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

	^ ScopeSelectorPresenter iconName
]

{ #category : #executing }
ApplyRuleOnSelectedClassesCommand >> execute [

	| dialogWindow changes |
	self flag:
		'Need to refactor this. the message scopeSelectorPresenteris specific to RTRuleEditorPresenter.'.
	dialogWindow := self context scopeSelectorPresenter openAsDialog.
	dialogWindow okAction: [
		| ruleHolder |
		ruleHolder := RTRuleHolder
			lhs: self context lhs
			rhs: self context rhs
			isForMethod: self context isRuleForMethod.

		changes := RTAbstractApplier defaultEngineApplier
			calculateChangesForClasses: self context scopeSelectorPresenter selectedClasses
			transformationRules: ruleHolder asOrderedCollection.
		(ChangesBrowser changes: changes) open ]
]
