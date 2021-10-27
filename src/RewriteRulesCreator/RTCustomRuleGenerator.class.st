"
I store custom Rewrite Rules as a subclass of `RBTransformationRule`. These custom rules are the ones that you store using the RewriteBasicEditorPresenter and the ones that you can load using the RewriteRuleLoaderPresenter.

Before you save the rule, you must set the value of my instance variables: searchFor and replaceWith.

An example of use:
` | ruleGenerator | 
ruleGenerator := CustomRuleGenerator new
		searchFor: '';
		replaceWith: ';
		inputCode: '';
		outputCode: ''.
ruleGenerator storeRule: aDefaultRuleName`
(The aDefaultRuleName can be an empty string, nil, or a rule name)
"
Class {
	#name : #RTCustomRuleGenerator,
	#superclass : #Object,
	#instVars : [
		'searchFor',
		'replaceWith',
		'inputCode',
		'outputCode'
	],
	#category : #'RewriteRulesCreator-Core'
}

{ #category : #accessing }
RTCustomRuleGenerator class >> getAllRules [

	^ CustomRewriteRule subclasses
]

{ #category : #accessing }
RTCustomRuleGenerator class >> getOnlyCustomRules [

	^ CustomRewriteRule subclasses reject: [ :rule | 
		  rule new isDemoRule ]
]

{ #category : #api }
RTCustomRuleGenerator class >> obtainChanges: methods forRules: rules [

	| critiques changes |
	critiques := self obtainCritiques: methods forRules: rules.
	"At this point you have a collection of critiques. Each critique can tell you which rule created it, and which target it criticizes.
	As the critiques are 'smart', the type you have here (node replace critiques) can give you change compatible with the ChangesBrowser or RewriteChangesBrowser."
	changes := critiques collect: #change.
	^ changes
]

{ #category : #api }
RTCustomRuleGenerator class >> obtainChangesForRuleAsAssociation: ruleAssociation isForMethod: aBoolean [

	| allSystemMethods ruleName tempRule changes |
	allSystemMethods := (RPackage organizer packages flatCollect:
		                     #classes) flatCollect: #methods.
	ruleName := 'AppliedRule' , (1 to: 100000) atRandom asString.
	tempRule := self new
		            searchFor: ruleAssociation key;
		            replaceWith: ruleAssociation value;
		            generateRule: ruleName
		            forPackage: self packageName
		            isForMethod: aBoolean.
	changes := self
		           obtainChanges: allSystemMethods
		           forRules: { tempRule new }.
	"tempRule removeFromSystem."
	^ changes
]

{ #category : #api }
RTCustomRuleGenerator class >> obtainCritiques: methods forRules: rules [

	"This is a way to obtain the same changes array as obtainChanges:forRule: method. But, here this is done without an RBClassEnvironment and ReSmalllintChecker. Because those two classes inherits from RB rules and will be eventually will be deprecated."

	"Take the methods and apply the rule on each of them (in fact on their nodes).
Take a look on ReCriticEngine for some automation ideas. Also take a look at CompiledMethod >> #critiques"

	| methodsAsSet critiques rewriteNode |
	"Extract all the methods from the needed classes.
	asSet message is needed because sometimes can return duplicated methods of the same classes."
	methodsAsSet := methods asSet.
	critiques := OrderedCollection new.
	rewriteNode := ReNodeRewriteRule new.
	rules do: [ :aRule | 
		aRule isForMethod
			ifTrue: [ rewriteNode addMatchingMethod: aRule lhs rewriteTo: aRule rhs ]
			ifFalse: [ rewriteNode addMatchingExpression: aRule lhs rewriteTo: aRule rhs ] ].
	methodsAsSet
		do: [ :method | 
			| rulesCritiques |
			"We need to run the rule for each method and combine resulting critiques.
						 In fact rewrite rules check AST nodes. So, we need to run the rule for every AST node of the method and combine the results."
			rulesCritiques := method ast allChildren flatCollect: [ :node | 
				rewriteNode check: node ].

			"This is a hack. Resulting critiques will tell they reffer to a single AST node. But, as the rewriting functionality requires actual method instances, we go over each critique and reassign the source entity to the method."
			rulesCritiques do: [ :critique | 
				critique sourceAnchor initializeEnitity: method ].
			critiques addAll: rulesCritiques ]
		displayingProgress: [ :method | 'Running critics on: ' , method methodClass name ].
	^ critiques
]

{ #category : #accessing }
RTCustomRuleGenerator class >> packageName [

	^ 'RewriteCustomRules'
]

{ #category : #defaults }
RTCustomRuleGenerator >> doubleSingleQuotes: aString [

	| aStream |
	aStream := String new writeStream.
	aString do: [ :charac | 
		charac = $' ifTrue: [ aStream nextPut: charac ].
		aStream nextPut: charac ].
	^ aStream contents
]

{ #category : #private }
RTCustomRuleGenerator >> generateRule: aRuleName forPackage: aPackageName isForMethod: isForMethod [

	| ruleAsClass fullPackageName aRuleClassName |
	aRuleClassName := aRuleName asCamelCase.
	fullPackageName := self class packageName , '-' , aPackageName.
	ruleAsClass := CustomRewriteRule
		               subclass: aRuleClassName
		               instanceVariableNames: ''
		               classVariableNames: ''
		               package: fullPackageName.
	ruleAsClass
		compile: (isForMethod
				 ifTrue: [ self ruleInitializationMethodForMethod ]
				 ifFalse: [ self ruleInitializationMethod ])
		classified: 'initialization'.
	ruleAsClass
		compile: (self ruleNameMethod: aRuleName)
		classified: 'accessing'.
	^ ruleAsClass
]

{ #category : #api }
RTCustomRuleGenerator >> getInstanceRule: isForMethod [

	| rule |
	rule := ReNodeRewriteRule new.
	isForMethod
		ifTrue: [ rule replaceMethod: searchFor with: replaceWith ]
		ifFalse: [ rule replace: searchFor with: replaceWith ].
	^ rule
]

{ #category : #initialization }
RTCustomRuleGenerator >> initialize [

	super initialize.
	inputCode := ''.
	outputCode := ''
]

{ #category : #accessing }
RTCustomRuleGenerator >> inputCode [
	^ inputCode
]

{ #category : #'api - initialization' }
RTCustomRuleGenerator >> inputCode: anObject [
	inputCode := anObject
]

{ #category : #alerts }
RTCustomRuleGenerator >> invalidRuleNameAlert [

	^ UIManager default inform:
		'The name(s) you entered is not a valid class name. Please try again.'
]

{ #category : #accessing }
RTCustomRuleGenerator >> outputCode [
	^ outputCode
]

{ #category : #'api - initialization' }
RTCustomRuleGenerator >> outputCode: anObject [
	outputCode := anObject
]

{ #category : #accessing }
RTCustomRuleGenerator >> replaceWith [

	^ replaceWith
]

{ #category : #'api - initialization' }
RTCustomRuleGenerator >> replaceWith: aString [

	replaceWith := aString
]

{ #category : #accessing }
RTCustomRuleGenerator >> ruleInitializationMethod [

	^ 'initialize
	
	super initialize.
	lhs := ''' , (self doubleSingleQuotes: searchFor) , '''.
	rhs := ''' , (self doubleSingleQuotes: replaceWith) , '''.
	inputCode := ''' , (self doubleSingleQuotes: inputCode) , '''.
	outputCode := ''' , (self doubleSingleQuotes: outputCode) , '''.
	self replace: lhs with: rhs'
]

{ #category : #accessing }
RTCustomRuleGenerator >> ruleInitializationMethodForMethod [

	^ 'initialize
	
	super initialize.
	lhs := ''' , (self doubleSingleQuotes: searchFor) , '''.
	rhs := ''' , (self doubleSingleQuotes: replaceWith) , '''.
	inputCode := ''' , (self doubleSingleQuotes: inputCode) , '''.
	outputCode := ''' , (self doubleSingleQuotes: outputCode) , '''.
	isForMethod := true.
	self replaceMethod: lhs with: rhs'
]

{ #category : #accessing }
RTCustomRuleGenerator >> ruleNameMethod: aRuleName [

	^ String streamContents: [ :aStream | 
		  aStream << 'name' << String cr << '
	^ ' << '''' << aRuleName << '''' ]
]

{ #category : #alerts }
RTCustomRuleGenerator >> ruleSuccessfullyCreatedAlert [

	^ UIManager default inform: 'The rule was successfully created!'
]

{ #category : #accessing }
RTCustomRuleGenerator >> searchFor [

	^ searchFor
]

{ #category : #'api - initialization' }
RTCustomRuleGenerator >> searchFor: aString [

	searchFor := aString
]

{ #category : #api }
RTCustomRuleGenerator >> storeRule: aDefaultRuleName isForMethod: isForMethod [

	"aDefaultRuleName is a name that will be written in the prompt. Can be a name, an empty string or nil."

	| ruleName packageName newlyGeneratedRule className |
	searchFor isNil | replaceWith isNil ifTrue: [ 
		Exception signal:
			'You must set the values of searchFor and replaceWith with a pattern code.'.
		^ nil ].
	ruleName := UIManager default
		            request: 'Name of the Rule:'
		            initialAnswer: aDefaultRuleName.
	"If the user pressed the cancel button."
	ruleName ifNil: [ ^ nil ].
	packageName := UIManager default
		               request: 'Name of the Package:'
		               initialAnswer: 'Custom'.
	"If the user pressed the cancel button."
	packageName ifNil: [ ^ nil ].
	className := ruleName asCamelCase.
	className isValidGlobalName & packageName isNotEmpty ifFalse: [ 
		self invalidRuleNameAlert.
		^ nil ].
	newlyGeneratedRule := self
		                      generateRule: className
		                      forPackage: packageName
		                      isForMethod: isForMethod.
	self ruleSuccessfullyCreatedAlert.
	^ newlyGeneratedRule
]
