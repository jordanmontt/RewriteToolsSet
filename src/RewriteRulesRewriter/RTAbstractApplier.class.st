"
I am the abstract class for applying a code transformation
"
Class {
	#name : #RTAbstractApplier,
	#superclass : #Object,
	#category : #'RewriteRulesRewriter-Core'
}

{ #category : #api }
RTAbstractApplier class >> applyTransformationChanges: changes [

	| refactoringJob |
	refactoringJob := [ 
		changes do: [ :change | RBRefactoryChangeManager instance performChange: change ] ] asJob.
	refactoringJob
		title: 'Refactoring';
		run
]

{ #category : #api }
RTAbstractApplier class >> calculateAllChangesForRules: ruleHolderCollection [

	^ self subclassResponsibility
]

{ #category : #api }
RTAbstractApplier class >> calculateChangesForClasses: classes transformationRules: ruleHolderCollection [

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
