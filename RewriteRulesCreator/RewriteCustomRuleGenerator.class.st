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
	#name : #RewriteCustomRuleGenerator,
	#superclass : #Object,
	#instVars : [
		'searchFor',
		'replaceWith',
		'inputCode',
		'outputCode'
	],
	#category : #'RewriteRulesCreator-Core'
}

{ #category : #accesing }
RewriteCustomRuleGenerator class >> getAllRules [

	^ CustomRewriteRule subclasses
]

{ #category : #accesing }
RewriteCustomRuleGenerator class >> getOnlyCustomRules [

	^ CustomRewriteRule subclasses reject: [ :rule | 
		  rule new isDemoRule ]
]

{ #category : #api }
RewriteCustomRuleGenerator class >> obtainChanges: classes forRule: aRule [

	| critiques changes |
	critiques := self obtainCritiques: classes forRule: aRule.
	"At this point you have a collection of critiques. Each critique can tell you which rule created it, and which target it criticizes.
	As the critiques are 'smart', the type you have here (node replace critiques) can give you change compatible with the ChangesBrowser or RewriteChangesBrowser."
	changes := critiques collect: #change.
	^ changes
]

{ #category : #api }
RewriteCustomRuleGenerator class >> obtainCritiques: classes forRule: aRule [

	"This is a way to obtain the same changes array as obtainChanges:forRule: method. But, here this is done without an RBClassEnvironment and ReSmalllintChecker. Because those two classes inherits from RB rules and will be eventually will be deprecated."

	"Take the methods and apply the rule on each of them (in fact on their nodes).
Take a look on ReCriticEngine for some automation ideas. Also take a look at CompiledMethod >> #critiques"

	| methods critiques |
	"Extract all the methods from the needed classes."
	methods := (classes flatCollect: #methods) asSet.
	critiques := OrderedCollection new.
	methods
		do: [ :method | 
			| rulesCritiques |
			"We need to run the rule for each method and combine resulting critiques.
						 In fact rewrite rules check AST nodes. So, we need to run the rule for every AST node of the method and combine the results."
			rulesCritiques := method ast allChildren flatCollect: [ :node | 
				                  aRule check: node ].

			"This is a hack. Resulting critiques will tell they reffer to a single AST node. But, as the rewriting functionality requires actual method instances, we go over each critique and reassign the source entity to the method."
			rulesCritiques do: [ :critique | 
				critique sourceAnchor initializeEnitity: method ].
			critiques addAll: rulesCritiques ]
		displayingProgress: [ :method | 
		'Running critics on: ' , method methodClass name ].
	^ critiques
]

{ #category : #accesing }
RewriteCustomRuleGenerator class >> packageName [

	^ 'RewriteCustomRules'
]

{ #category : #defaults }
RewriteCustomRuleGenerator >> doubleSingleQuotes: aString [

	| aStream |
	aStream := String new writeStream.
	aString do: [ :charac | 
		charac = $' ifTrue: [ aStream nextPut: charac ].
		aStream nextPut: charac ].
	^ aStream contents
]

{ #category : #private }
RewriteCustomRuleGenerator >> generateRule: aRuleName forPackage: aPackageName [

	| ruleAsClass fullPackageName aRuleClassName |
	aRuleClassName := aRuleName asCamelCase.
	fullPackageName := self class packageName , '-' , aPackageName.
	ruleAsClass := CustomRewriteRule
		               subclass: aRuleClassName
		               instanceVariableNames: ''
		               classVariableNames: ''
		               package: fullPackageName.
	ruleAsClass
		compile: self ruleInitializationMethod
		classified: 'initialization'.
	ruleAsClass
		compile: (self ruleNameMethod: aRuleName)
		classified: 'accessing'.
	^ ruleAsClass
]

{ #category : #api }
RewriteCustomRuleGenerator >> getInstanceRule [

	^ ReNodeRewriteRule new
		  replace: searchFor with: replaceWith;
		  yourself
]

{ #category : #initialization }
RewriteCustomRuleGenerator >> initialize [

	super initialize.
	inputCode := ''.
	outputCode := ''
]

{ #category : #accessing }
RewriteCustomRuleGenerator >> inputCode [
	^ inputCode
]

{ #category : #'api - initialization' }
RewriteCustomRuleGenerator >> inputCode: anObject [
	inputCode := anObject
]

{ #category : #alerts }
RewriteCustomRuleGenerator >> invalidRuleNameAlert [

	^ UIManager default inform:
		'The name(s) you entered is not a valid class name. Please try again.'
]

{ #category : #accessing }
RewriteCustomRuleGenerator >> outputCode [
	^ outputCode
]

{ #category : #'api - initialization' }
RewriteCustomRuleGenerator >> outputCode: anObject [
	outputCode := anObject
]

{ #category : #accessing }
RewriteCustomRuleGenerator >> replaceWith [

	^ replaceWith
]

{ #category : #'api - initialization' }
RewriteCustomRuleGenerator >> replaceWith: aString [

	replaceWith := aString
]

{ #category : #accessing }
RewriteCustomRuleGenerator >> ruleInitializationMethod [

	^ 'initialize
	
	super initialize.
	lhs := ''' , (self doubleSingleQuotes: searchFor) , '''.
	rhs := ''' , (self doubleSingleQuotes: replaceWith) , '''.
	inputCode := ''' , (self doubleSingleQuotes: inputCode) , '''.
	outputCode := ''' , (self doubleSingleQuotes: outputCode) , '''.
	self replace: lhs with: rhs'
]

{ #category : #accessing }
RewriteCustomRuleGenerator >> ruleNameMethod: aRuleName [

	^ 'name
	
	^ ''' , aRuleName , '''
	'
]

{ #category : #alerts }
RewriteCustomRuleGenerator >> ruleSuccessfullyCreatedAlert [

	^ UIManager default inform: 'The rule was successfully created!'
]

{ #category : #accessing }
RewriteCustomRuleGenerator >> searchFor [

	^ searchFor
]

{ #category : #'api - initialization' }
RewriteCustomRuleGenerator >> searchFor: aString [

	searchFor := aString
]

{ #category : #api }
RewriteCustomRuleGenerator >> storeRule: aDefaultRuleName [

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
		                      generateRule:  className
		                      forPackage: packageName.
	self ruleSuccessfullyCreatedAlert.
	^ newlyGeneratedRule
]
