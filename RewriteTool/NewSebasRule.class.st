Class {
	#name : #NewSebasRule,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteTool-TestsData'
}

{ #category : #initialization }
NewSebasRule >> initialize [
	super initialize.
	self lhs: '| temp |
self isNilffff
	ifTrue: [ ^ true ].
temp size'.self rhs: '| temp |
self isNil
	ifTrue: [ ^ true ].
temp size'.self input: '| temp |
self isNil
	ifTrue: [ ^ true ].
temp size'.self output: '| temp |
self isNil
	ifTrue: [ ^ true ].
temp size'.
	self rewriteRule
		replace: lhs
		with: rhs
]
