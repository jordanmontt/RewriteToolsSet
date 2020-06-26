Class {
	#name : #DefaultRule,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteCustomRules-Demo'
}

{ #category : #initialization }
DefaultRule >> initialize [
	super initialize.
	searchFor := '| ``@object |
`.@Statement1.
``@object ifNotNil: [ `.@Statement2.
`.@Statement3.
`.@Statement4.
`.@Statement5 ]'.
	replaceWith := '| ``@object |
`.@Statement1.
``@object ifNil: [ ^ self ].
`.@Statement2.
`.@Statement3.
`.@Statement4.
`.@Statement5'.
	input := ''.
	output := ''.
	rewriteRule replace: searchFor with: replaceWith
]
