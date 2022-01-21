"
I use the RB rules to apply transformation rules to a set of methods
"
Class {
	#name : #RTRBApplier,
	#superclass : #RTAbstractApplier,
	#category : #'RewriteRulesCreator-Core'
}

{ #category : #api }
RTRBApplier class >> changesOf: classes forRules: ruleHolderCollection [

	| env rewriter |
	env := self createScopeEnvironmentForClasses: classes.
	rewriter := self rewriter: ruleHolderCollection.

	^ self obtainChanges: env rewriter: rewriter
]

{ #category : #api }
RTRBApplier class >> changesOfAllMethodsFor: ruleHolderCollection [

	| env rewriter |
	env :=self scopeEnvironmentForAllPackages.
	rewriter := self rewriter: ruleHolderCollection.

	^ self obtainChanges: env rewriter: rewriter
]

{ #category : #api }
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
