"
I am the default rewrite rule that is loaded when RewriteBasicEditorPresenter is opened.
"
Class {
	#name : #DemoRule1,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteRulesCreator-Demo'
}

{ #category : #initialization }
DemoRule1 >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '| `object |
`.Statement1.
`object ifNotNil: [ 
	`.Statement2.
	`.Statement3.
	`.Statement4.
	`.Statement5 ]'.
	replaceWithPattern := '| `object |
`.Statement1.
`object ifNil: [ self ].
`.Statement2.
`.Statement3.
`.Statement4.
`.Statement5'.
	input := ''.
	output := ''.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
