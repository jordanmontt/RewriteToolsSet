"
I use the RB rules to apply transformation rules to a set of methods
"
Class {
	#name : #RTRBApplier,
	#superclass : #RTAbstractApplier,
	#category : #'RewriteRulesRewriter-Core'
}

{ #category : #api }
RTRBApplier class >> changesOf: classes forRules: ruleHolderCollection [

	| env rewriter |
	env := RTEnvironmentCreator scopeEnvironmentForClasses: classes.
	rewriter := self rewriter: ruleHolderCollection.

	^ self obtainChanges: env rewriter: rewriter
]

{ #category : #api }
RTRBApplier class >> changesOfAllMethodsFor: ruleHolderCollection [

	| env rewriter |
	env := RTEnvironmentCreator scopeEnvironmentForAllPackages.
	rewriter := self rewriter: ruleHolderCollection.

	^ self obtainChanges: env rewriter: rewriter
]

{ #category : #api }
RTRBApplier class >> changesToAllClassesAssociation: ruleAsAssociation isForMethod: aBoolean [

	| ruleHolder env rewriter |
	env := RTEnvironmentCreator scopeEnvironmentForAllPackages.
	ruleHolder := self createRuleHolder: ruleAsAssociation  isforMethod: aBoolean.
	rewriter := self rewriter: { ruleHolder }.

	^ self obtainChanges: env rewriter: rewriter
]

{ #category : #api }
RTRBApplier class >> changesToClasses: classes association: ruleAsAssociation isForMethod: aBoolean [

	| ruleHolder env rewriter |
	env := RTEnvironmentCreator scopeEnvironmentForClasses: classes.
	ruleHolder := self createRuleHolder: ruleAsAssociation isforMethod: aBoolean.
	rewriter := self rewriter: { ruleHolder }.

	^ self obtainChanges: env rewriter: rewriter
]

{ #category : #private }
RTRBApplier class >> obtainChanges: env rewriter: rewriter [

	| checker transformationRule |
	transformationRule := RBTransformationRule new
		rewriteRule: rewriter;
		yourself.
	
	checker := RBSmalllintChecker new
		rule: transformationRule;
		environment: env.
	checker run.

	^ transformationRule changes
]

{ #category : #private }
RTRBApplier class >> rewriter: ruleHolderCollection [

	| rewriter |
	rewriter := RBParseTreeRewriter new.
	ruleHolderCollection do: [ :ruleHolder | 
		ruleHolder isForMethod
			ifTrue: [ rewriter replaceMethod: ruleHolder lhs with: ruleHolder rhs ]
			ifFalse: [ rewriter replace: ruleHolder lhs with: ruleHolder rhs ] ].
	^ rewriter
]
