"
I am an extension of `RBTransformationRule`.

The rules created using the `RewriteRuleBuilderPresenter` are stored using an instance of me. They use me and not RBTransformationRule directly because the input and output code are need to stored as well. 


input
- the Pharo code that was abstracted and converted into a Rewrite Rule.

output
- the Pharo's code that is the result of applying the Rewrite Rule to the input code.

lhs
- the searchFor part of the rewriter.

rhs
- the replaceWith part of the rewriter.
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
