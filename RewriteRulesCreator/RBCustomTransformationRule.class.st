"
An extention of the RBTransformationRule to store Custom Rewrite Rules.
"
Class {
	#name : #RBCustomTransformationRule,
	#superclass : #RBTransformationRule,
	#instVars : [
		'input',
		'output'
	],
	#category : #'RewriteRulesCreator-Core'
}

{ #category : #accessing }
RBCustomTransformationRule >> input [

	^ input
]

{ #category : #accessing }
RBCustomTransformationRule >> input: anObject [

	input := anObject
]

{ #category : #accessing }
RBCustomTransformationRule >> output [

	^ output
]

{ #category : #accessing }
RBCustomTransformationRule >> output: anObject [

	output := anObject
]
