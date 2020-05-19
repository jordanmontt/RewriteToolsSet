Class {
	#name : #SebasRule,
	#superclass : #RBCustomTransformationRule,
	#category : #'RewriteTool-TestsData'
}

{ #category : #initialization }
SebasRule >> initialize [
	super initialize.
	self lhs: '`variable1 isNil
	ifTrue: `@block1.
`.Statement1'.self rhs: '`variable1 ifNil: `@block1.
`.Statement1'.self input: ''.self output: ''.
	self rewriteRule
		replace: lhs
		with: rhs
]
