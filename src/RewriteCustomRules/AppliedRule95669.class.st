Class {
	#name : #AppliedRule95669,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-RewriteCustomRules'
}

{ #category : #initialization }
AppliedRule95669 >> initialize [
	
	super initialize.
	lhs := '(`@receiver collect: `@arg) flattened'.
	rhs := '`@receiver flatCollect: `@arg'.
	inputCode := ''.
	outputCode := ''.
	self replace: lhs with: rhs
]

{ #category : #accessing }
AppliedRule95669 >> name [

	^ 'AppliedRule95669'
]
