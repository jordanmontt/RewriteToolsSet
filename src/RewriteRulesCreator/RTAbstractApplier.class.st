"
I am the abstract class for applying a code transformation
"
Class {
	#name : #RTAbstractApplier,
	#superclass : #Object,
	#category : #'RewriteRulesCreator-Core'
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
RTAbstractApplier class >> createScopeEnvironmentForClasses: classes [

	^ RBClassEnvironment classes: classes
]

{ #category : #api }
RTAbstractApplier class >> scopeEnvironmentForAllPackages [

	^ RBPackageEnvironment packages: RPackageOrganizer default packages
]
