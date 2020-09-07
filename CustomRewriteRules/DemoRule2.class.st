"
I am a Demo Rewrite Rule.
"
Class {
	#name : #DemoRule2,
	#superclass : #RBTransformationRule,
	#category : #'CustomRewriteRules-Demo'
}

{ #category : #initialization }
DemoRule2 >> initialize [

	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern :=  '`@receiver select: [:`each | | `@temps | ``@.Statements. ``@object not]'.
	replaceWithPattern := '`@receiver reject: [:`each | | `@temps | ``@.Statements. ``@object]'.
	rewriteRule replace: searchForPattern with: replaceWithPattern
]
