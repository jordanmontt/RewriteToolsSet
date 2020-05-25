Class {
	#name : #NewRule,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteToolCustomRules-Custom'
}

{ #category : #initialization }
NewRule >> initialize [
	super initialize.
	self searchFor: '| ``@object |
`.@Statement1
``@object ifNil: [ ^ self ].
`.@Statement1
`.@Statement2'.
	self replaceWith: '| ``@object |
`.@Statement1
``@object ifNotNil: [ `.@Statement1
`.@Statement2 ]'.
	self input: ''.
	self output: ''.
	self rewriteRule
		replace: searchFor
		with: replaceWith
]
