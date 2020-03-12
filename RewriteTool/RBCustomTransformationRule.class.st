Class {
	#name : #RBCustomTransformationRule,
	#superclass : #RBTransformationRule,
	#instVars : [
		'input',
		'output',
		'lhs',
		'rhs'
	],
	#category : #'RewriteTool-Rules'
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
RBCustomTransformationRule >> lhs [
	^ lhs
]

{ #category : #accessing }
RBCustomTransformationRule >> lhs: anObject [
	lhs := anObject
]

{ #category : #accessing }
RBCustomTransformationRule >> output [
	^ output
]

{ #category : #accessing }
RBCustomTransformationRule >> output: anObject [
	output := anObject
]

{ #category : #accessing }
RBCustomTransformationRule >> rhs [
	^ rhs
]

{ #category : #accessing }
RBCustomTransformationRule >> rhs: anObject [
	rhs := anObject
]
