Class {
	#name : #SebasRule54,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteToolCustomRules-Custom'
}

{ #category : #initialization }
SebasRule54 >> initialize [
	super initialize.
	self searchFor: '| temp |
self isNil
	ifTrue: [ ^ true ].
temp size'.
	self replaceWith: '| temp |
self isNil
	ifTrue: [ ^ true ].
temp size'.
	self input: ''.
	self output: ''.
	self rewriteRule
		replace: searchFor
		with: replaceWith
]
