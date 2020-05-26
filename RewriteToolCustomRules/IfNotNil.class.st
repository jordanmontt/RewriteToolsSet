"
a Custom Rule
"
Class {
	#name : #IfNotNil,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteToolCustomRules-Custom'
}

{ #category : #initialization }
IfNotNil >> initialize [
	super initialize.
	self searchFor: '| ``@object |
`.@Statement1.
``@object
	ifNotNil: [ `.@Statement2.
		`.@Statement3.
		`.@Statement4.
		`.@Statement5 ]'.
	self replaceWith: '| ``@object |
`.@Statement1.
``@object ifNil: [ ^ self ].
`.@Statement2.
`.@Statement3.
`.@Statement4.
`.@Statement5'.
	self input: ''.
	self output: ''.
	self rewriteRule
		replace: searchFor
		with: replaceWith
]
