"
I am an extension of `RBTransformationRule`.

The rules created using the `RewriteRuleBuilderPresenter` are stored using an instance of me. They use me and not RBTransformationRule directly because the input and output code are need to stored as well. 
 
- input: the Pharo code that was abstracted and converted into a Rewrite Rule.

- output: the Pharo's code that is the result of applying the Rewrite Rule to the input code.

- lhs: the searchFor part of the rewriter.

- rhs: the replaceWith part of the rewriter.
"
Class {
	#name : #CustomRewriteRule,
	#superclass : #ReNodeRewriteRule,
	#instVars : [
		'inputCode',
		'outputCode',
		'lhs',
		'rhs'
	],
	#category : #'RewriteRulesCreator-Core'
}

{ #category : #initialization }
CustomRewriteRule >> initialize [

	super initialize.
	inputCode := ''.
	outputCode := ''.
	lhs := ''.
	rhs := ''
]

{ #category : #accessing }
CustomRewriteRule >> inputCode [

	^ inputCode
]

{ #category : #accessing }
CustomRewriteRule >> inputCode: aString [

	inputCode := aString
]

{ #category : #testing }
CustomRewriteRule >> isDemoRule [

	^ false
]

{ #category : #accessing }
CustomRewriteRule >> lhs [

	^ lhs
]

{ #category : #accessing }
CustomRewriteRule >> name [

	"Answer a human readable name of the rule."

	^ 'A children class of ReNodeRewriteRule.'
]

{ #category : #accessing }
CustomRewriteRule >> outputCode [

	^ outputCode
]

{ #category : #accessing }
CustomRewriteRule >> outputCode: aString [

	outputCode := aString
]

{ #category : #accessing }
CustomRewriteRule >> rhs [

	^ rhs
]
