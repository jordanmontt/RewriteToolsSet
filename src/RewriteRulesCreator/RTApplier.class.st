"
I am a class that is in charge to apply a rule, that is represented in an object `RTRuleHolder` to the methods inside the Pharo image.
"
Class {
	#name : #RTApplier,
	#superclass : #Object,
	#category : #'RewriteRulesCreator-Saver'
}

{ #category : #api }
RTApplier class >> obtainChanges: methods forRules: rules [

	| critiques changes |
	critiques := self obtainCritiques: methods forRules: rules.
	"At this point you have a collection of critiques. Each critique can tell you which rule created it, and which target it criticizes.
	As the critiques are 'smart', the type you have here (node replace critiques) can give you change compatible with the ChangesBrowser or RewriteChangesBrowser."
	changes := critiques collect: #change.
	^ changes
]

{ #category : #api }
RTApplier class >> obtainChangesForRuleAsAssociation: ruleAssociation isForMethod: aBoolean [

	| allSystemMethods ruleHolder changes |
	allSystemMethods := (RPackage organizer packages flatCollect: #classes)
		flatCollect: #methods.
	ruleHolder := RTRuleHolder
		lhs: ruleAssociation key
		rhs: ruleAssociation value
		isForMethod: aBoolean.
	changes := self obtainChanges: allSystemMethods forRules: { ruleHolder }.
	^ changes
]

{ #category : #api }
RTApplier class >> obtainCritiques: methods forRules: ruleHolderCollection [

	"This is a way to obtain the same changes array as obtainChanges:forRule: method. But, here this is done without an RBClassEnvironment and ReSmalllintChecker. Because those two classes inherits from RB rules and will be eventually will be deprecated."

	"Take the methods and apply the rule on each of them (in fact on their nodes).
Take a look on ReCriticEngine for some automation ideas. Also take a look at CompiledMethod >> #critiques"

	| methodsAsSet critiques rewriteNode |
	"Extract all the methods from the needed classes.
	asSet message is needed because sometimes can return duplicated methods of the same classes."
	methodsAsSet := methods asSet.
	critiques := OrderedCollection new.
	rewriteNode := ReNodeRewriteRule new.
	ruleHolderCollection do: [ :aRuleHolder | 
		aRuleHolder isForMethod
			ifTrue: [ rewriteNode addMatchingMethod: aRuleHolder lhs rewriteTo: aRuleHolder rhs ]
			ifFalse: [ rewriteNode addMatchingExpression: aRuleHolder lhs rewriteTo: aRuleHolder rhs ] ].
	methodsAsSet do: [ :method | 
		| rulesCritiques |
			"We need to run the rule for each method and combine resulting critiques.
						 In fact rewrite rules check AST nodes. So, we need to run the rule for every AST node of the method and combine the results."
		rulesCritiques := method ast allChildren flatCollect: [ :node | 
			rewriteNode check: node ].

			"This is a hack. Resulting critiques will tell they reffer to a single AST node. But, as the rewriting functionality requires actual method instances, we go over each critique and reassign the source entity to the method."
		rulesCritiques do: [ :critique | critique sourceAnchor initializeEnitity: method ].
		critiques addAll: rulesCritiques ]
	displayingProgress: [ :method | 'Running critics on: ' , method methodClass name ].
	^ critiques
]
