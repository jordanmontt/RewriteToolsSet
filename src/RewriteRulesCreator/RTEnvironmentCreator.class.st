"
I am a class that creates an environment in which a set of rewrite rules can be applied.
"
Class {
	#name : #RTEnvironmentCreator,
	#superclass : #Object,
	#category : #'RewriteRulesCreator-Core'
}

{ #category : #api }
RTEnvironmentCreator class >> createScopeEnvironmentForClasses: classes [

	^ RBClassEnvironment classes: classes
]

{ #category : #api }
RTEnvironmentCreator class >> scopeEnvironmentForAllPackages [

	^ RBPackageEnvironment packages: RPackageOrganizer default packages
]
