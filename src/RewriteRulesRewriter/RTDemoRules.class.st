"
I am a class that creates some demo rules to be used as rule examples
"
Class {
	#name : #RTDemoRules,
	#superclass : #Object,
	#category : #'RewriteRulesRewriter-DefaultRule'
}

{ #category : #api }
RTDemoRules class >> defaultRule [

	| lhs rhs inputCode |
	lhs := '(`@receiver collect: `@arg) flattened'.
	rhs := '`@receiver flatCollect: `@arg'.
	inputCode := '(RBBrowserEnvironment default packages collect: #classes) flattened'.
	^ RTRuleHolder lhs: lhs rhs: rhs pharoCode: inputCode
]

{ #category : #api }
RTDemoRules class >> demoRules [

	^ {
		  self simplifyToIfNilIfNotNilRule.
		  self replaceAssertToAssertEmptyRule.
		  self simpliflyConditionalToIsEmptyRule.
		  self removeEqualsInAssertRule.
		  self replaceDenyDenyEmptyRule.
		  self replaceCharacterTabAsStringToStringTabRule.
		  self simpliflyToIfEmptyIfNotEmptyRule.
		  self removeIfNilRule.
		  self replaceSelectToRejectRule.
		  self removeAssignmentWithoutEffectRule.
		  self replaceCollectFlattenToFlatCollectRule }
]

{ #category : #rules }
RTDemoRules class >> removeAssignmentWithoutEffectRule [

	| lhs rhs ruleName |
	lhs := '`var := `var'.
	rhs := ''.
	ruleName := 'Remove assignment without effect'.
	^ RTRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : #rules }
RTDemoRules class >> removeEqualsInAssertRule [

	| lhs rhs ruleName |
	lhs := '`@receiver assert: `@arg equals: true'.
	rhs := '`@receiver assert: `@arg'.
	ruleName := 'Remove equals in assert'.
	^ RTRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : #rules }
RTDemoRules class >> removeIfNilRule [

	| lhs rhs ruleName |
	lhs := '`@receiver ifNil: [ nil ] ifNotNil: `@arg'.
	rhs := '`@receiver ifNotNil: `@arg'.
	ruleName := 'Remove unnecessary ifNil:'.
	^ RTRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : #rules }
RTDemoRules class >> replaceAssertToAssertEmptyRule [

	| lhs rhs ruleName |
	lhs := '`@receiver assert: `@arg isEmpty'.
	rhs := '`@receiver assertEmpty: `@arg'.
	ruleName := 'Replace assert to assert empty'.
	^ RTRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : #rules }
RTDemoRules class >> replaceCharacterTabAsStringToStringTabRule [

	| lhs rhs ruleName |
	lhs := 'Character tab asString'.
	rhs := 'String tab'.
	ruleName := 'Replace Character tab asString to String tab'.
	^ RTRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : #rules }
RTDemoRules class >> replaceCollectFlattenToFlatCollectRule [

	| lhs rhs ruleName |
	lhs := '(`@receiver collect: `@arg) flattened'.
	rhs := '`@receiver flatCollect: `@arg'.
	ruleName := 'Replace collect: flatten to flatCollect:'.
	^ RTRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : #rules }
RTDemoRules class >> replaceDenyDenyEmptyRule [

	| lhs rhs ruleName |
	lhs := '`@receiver select: [ :`each |
	| `@temps |
	``@.Statements.
	``@object not ]'.
	rhs := '`@receiver denyEmpty: `@arg'.
	ruleName := 'Replace deny: isEmpty to denyEmpty:'.
	^ RTRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : #rules }
RTDemoRules class >> replaceSelectToRejectRule [

	| lhs rhs ruleName |
	lhs := '`@receiver select: [ :`each |
	| `@temps |
	``@.Statements.
	``@object not ]'.
	rhs := '`@receiver reject: [ :`each |
	| `@temps |
	``@.Statements.
	``@object ]'.
	ruleName := 'Replace select to reject'.
	^ RTRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : #rules }
RTDemoRules class >> simpliflyConditionalToIsEmptyRule [

	| lhs rhs ruleName |
	lhs := '`@receiver ifEmpty: [ true ] ifNotEmpty: [ false ]'.
	rhs := '`@receiver isEmpty'.
	ruleName := 'Simplify conditional to isEmpty'.
	^ RTRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : #rules }
RTDemoRules class >> simpliflyToIfEmptyIfNotEmptyRule [

	| lhs rhs ruleName |
	lhs := '`@receiver isEmpty ifTrue: `@arg ifFalse: `@arg2'.
	rhs := '`@receiver ifEmpty: `@arg ifNotEmpty: `@arg2'.
	ruleName := 'Simplify to ifEmpty: ifNotEmpty:'.
	^ RTRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : #rules }
RTDemoRules class >> simplifyToIfNilIfNotNilRule [

	| lhs rhs ruleName |
	lhs := '`@receiver isNil
	ifTrue: `@arg
	ifFalse: `@arg2'.
	rhs := '`@receiver ifNil: `@arg ifNotNil: `@arg2'.
	ruleName := 'Simplify to ifNil: ifNotNil:'.
	^ RTRuleHolder lhs: lhs rhs: rhs name: ruleName
]
