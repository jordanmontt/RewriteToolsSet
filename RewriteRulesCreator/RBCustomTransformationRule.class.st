"
I am an extension of `RBTransformationRule`.

The rules created using the `RewriteRuleBuilderPresenter` are stored using an instance of me. They use me and not RBTransformationRule directly because the input and output code are need to stored as well. 
 
- input: the Pharo code that was abstracted and converted into a Rewrite Rule.

- output: the Pharo's code that is the result of applying the Rewrite Rule to the input code.

- lhs: the searchFor part of the rewriter.

- rhs: the replaceWith part of the rewriter.
"
Class {
	#name : #RBCustomTransformationRule,
	#superclass : #RBTransformationRule,
	#instVars : [
		'inputCode',
		'outputCode'
	],
	#category : #'RewriteRulesCreator-Core'
}

{ #category : #initialization }
RBCustomTransformationRule >> initialize [

	super initialize.
	inputCode := ''.
	outputCode := ''
]

{ #category : #accessing }
RBCustomTransformationRule >> inputCode [

	^ inputCode
]

{ #category : #accessing }
RBCustomTransformationRule >> inputCode: aString [

	inputCode := aString
]

{ #category : #accessing }
RBCustomTransformationRule >> outputCode [

	^ outputCode
]

{ #category : #accessing }
RBCustomTransformationRule >> outputCode: aString [

	outputCode := aString
]
