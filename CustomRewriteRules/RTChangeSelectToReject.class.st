"
I am a Demo Rewrite Rule.
"
Class {
	#name : #RTChangeSelectToReject,
	#superclass : #RBCustomTransformationRule,
	#category : #'CustomRewriteRules-Examples'
}

{ #category : #initialization }
RTChangeSelectToReject >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern :=  '`@receiver select: [:`each | | `@temps | ``@.Statements. ``@object not]'.
	replaceWithPattern := '`@receiver reject: [:`each | | `@temps | ``@.Statements. ``@object]'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
