"
A custom rewrite rule
"
Class {
	#name : #DemoRule3,
	#superclass : #RBTransformationRule,
	#category : #'RewriteRulesCreator-Demo'
}

{ #category : #initialization }
DemoRule3 >> initialize [
	super initialize.
	self rewriteRule
		replace:
			'true not
		ifTrue: [ ^ 1 + 1 ]
		ifFalse: [ ^ 1 + 0 ]'
		with: 'false
		ifTrue: [ ^ 1 + 1 ]
		ifFalse: [ ^ 1 + 0 ]'
				
]
