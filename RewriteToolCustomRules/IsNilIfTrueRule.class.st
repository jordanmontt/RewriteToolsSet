Class {
	#name : #IsNilIfTrueRule,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteToolCustomRules-Custom'
}

{ #category : #initialization }
IsNilIfTrueRule >> initialize [
	super initialize.
	self searchFor: '| ``@object |
`.@Statement1
``@object isNil 
    ifTrue: [ ^ self ].
`.@Statement1
`.@Statement2
`.@Statement3
`.@Statement4
'.
	self replaceWith: '| ``@object |
`.@Statement1
``@object isNotNil 
    ifTrue: [ `.@Statement1
`.@Statement2
`.@Statement3
`.@Statement4 ]'.
	self input: ''.
	self output: ''.
	self rewriteRule
		replace: searchFor
		with: replaceWith
]
