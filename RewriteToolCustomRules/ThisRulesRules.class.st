Class {
	#name : #ThisRulesRules,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteToolCustomRules-Custom'
}

{ #category : #initialization }
ThisRulesRules >> initialize [
	super initialize.
	self searchFor: '| ``@object |
`.@Statement1
``@object ifNil: [ ^ self ].
`.@Statement1
`.@Statement2
`.@Statement3
`.@Statement4'.
	self replaceWith: '| ``@object |
`.@Statement1
``@object ifNotNil: [ `.@Statement1
`.@Statement2
`.@Statement3
`.@Statement4 ]'.
	self input: ''.
	self output: ''.
	self rewriteRule
		replace: searchFor
		with: replaceWith
]
