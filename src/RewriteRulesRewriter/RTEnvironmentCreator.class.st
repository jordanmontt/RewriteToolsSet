"
I am a class that creates an environment in which a set of rewrite rules can be applied.
"
Class {
	#name : #RTEnvironmentCreator,
	#superclass : #Object,
	#category : #'RewriteRulesRewriter-Core'
}

{ #category : #api }
RTEnvironmentCreator class >> scopeEnvironmentForAllPackages [

	^ RBPackageEnvironment packages: RPackageOrganizer default packages
]

{ #category : #api }
RTEnvironmentCreator class >> scopeEnvironmentForClasses: classes [

	^ RBClassEnvironment classes: classes
]
