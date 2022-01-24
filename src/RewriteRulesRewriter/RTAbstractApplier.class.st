"
I am the abstract class for applying a code transformation
"
Class {
	#name : #RTAbstractApplier,
	#superclass : #Object,
	#category : #'RewriteRulesRewriter-Core'
}

{ #category : #api }
RTAbstractApplier class >> changesOf: classes forRules: ruleHolderCollection [

	^ self subclassResponsibility
]

{ #category : #api }
RTAbstractApplier class >> changesOfAllMethodsFor: ruleHolderCollection [

	^ self subclassResponsibility
]

{ #category : #api }
RTAbstractApplier class >> changesToAllClassesAssociation: ruleAsAssociation isForMethod: aBoolean [

	^ self subclassResponsibility
]

{ #category : #api }
RTAbstractApplier class >> changesToClasses: classes association: ruleAsAssociation isForMethod: aBoolean [

	^ self subclassResponsibility
]

{ #category : #private }
RTAbstractApplier class >> createRuleHolder: ruleAsAssociation isforMethod: aBoolean [

	^ RTRuleHolder
		lhs: ruleAsAssociation key
		rhs: ruleAsAssociation value
		isForMethod: aBoolean
]

{ #category : #api }
RTAbstractApplier class >> defaultEngineApplier [

	^ RTRBApplier
]
