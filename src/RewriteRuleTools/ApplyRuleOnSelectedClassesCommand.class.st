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
ApplyRuleOnSelectedClassesCommand class >> defaultName [

	^ 'Transform selected classes'
]

{ #category : #accessing }
ApplyRuleOnSelectedClassesCommand class >> iconName [

	^ RTCodeTransformerPresenter iconName
]

{ #category : #executing }
ApplyRuleOnSelectedClassesCommand >> execute [

	| dialogWindow |
	dialogWindow := self context scopeSelectorPresenter openAsDialog.
	dialogWindow
		okAction: [ self context scopeSelectorPresenter scopeEnvironment ];
		resize: 530 @ 330
]
