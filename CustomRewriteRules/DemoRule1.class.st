"
I am a Demo Rewrite Rule.
"
Class {
	#name : #DemoRule1,
	#superclass : #RBCustomTransformationRule,
	#category : #'CustomRewriteRules-Demo'
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
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
