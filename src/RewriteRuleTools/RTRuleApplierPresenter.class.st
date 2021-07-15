"
I am a tool that provides a UI for applying a rewrite rule on a certain scope of classes.

In my left column, you can select one or many packages. When you do that, all of their classes will be automatically added to the scope. Also, if you do not want to apply the rewrite rule to all the package's classes, you can select the specific classes on which you want the rewrite rule to be applied.

The methods column shows all the methods the rewrite rule will change. You cannot apply the rewrite rule to a specific method, only to a set of classes.
Remember that multiple selection in supported.

You can open me whit:
`RewriteRuleApplierPresenter open`
"
Class {
	#name : #RTRuleApplierPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'applyOnSelectedClassesButton',
		'applyOnAllClassesButton',
		'openLoaderButton',
		'rulesTable',
		'openRulesTableButton',
		'methodsSelectorPresenter'
	],
	#category : #'RewriteRuleTools-Applier'
}

{ #category : #accessing }
RTRuleApplierPresenter class >> descriptionText [

	^ 'Apply your custom rewrite rules to any packages or classes'
]

{ #category : #accessing }
RTRuleApplierPresenter class >> icon [
	^ self iconNamed: #objects
]

{ #category : #api }
RTRuleApplierPresenter class >> open [

	<script>
	^ self new openWithSpec
]

{ #category : #api }
RTRuleApplierPresenter class >> runReplaceOnAllClasses: aRulesCollection [

	| changes allSystemMethods |
	allSystemMethods := (RPackage organizer packages flatCollect:
		                     #classes) flatCollect: #methods.
	changes := RTCustomRuleGenerator
		           obtainChanges: allSystemMethods
		           forRules: aRulesCollection.
	^ (RTChangesBrowser changes: changes) open
]

{ #category : #api }
RTRuleApplierPresenter class >> runReplaceWithRuleAsAssociation: ruleAssociation isForMethod: aBoolean [

	| changes |
	changes := RTCustomRuleGenerator
		           obtainChangesForRuleAsAssociation: ruleAssociation
		           isForMethod: aBoolean.
	^ (RTChangesBrowser changes: changes) open
]

{ #category : #accessing }
RTRuleApplierPresenter class >> title [

	^ 'Rewrite Rule Applier'
]

{ #category : #initialization }
RTRuleApplierPresenter >> connectPresenters [

	applyOnSelectedClassesButton action: [ self runReplace ].
	applyOnAllClassesButton action: [ self runReplaceOnAllClasses ].
	openLoaderButton action: [ self openLoader ].
	openRulesTableButton action: [ self manageRulesTableWindow ]
]

{ #category : #initialization }
RTRuleApplierPresenter >> initializeButtons [

	openRulesTableButton := self newButton
		                        label: 'Select rules to apply';
		                        icon: (self iconNamed: #checkboxSelected);
		                        yourself.
	applyOnSelectedClassesButton := self newButton
		                                label: 'On selected classes';
		                                icon: self class icon;
		                                yourself.
	applyOnAllClassesButton := self newButton
		                           label: 'On all classes';
		                           icon: self class icon;
		                           yourself.
	openLoaderButton := self newButton
		                    label: 'Open Rule Loader';
		                    icon: RTRuleLoaderPresenter icon
]

{ #category : #initialization }
RTRuleApplierPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: #methodsSelectorPresenter;
			 addLast: (SpBoxLayout newLeftToRight
					  add: #openRulesTableButton width: 160;
					  addLast: #applyOnSelectedClassesButton;
					  addLast: #applyOnAllClassesButton;
					  addLast: #openLoaderButton;
					  yourself);
			 yourself)
]

{ #category : #initialization }
RTRuleApplierPresenter >> initializeMethodsSelector [

	methodsSelectorPresenter := MethodsSelectorPresenter new
]

{ #category : #initialization }
RTRuleApplierPresenter >> initializePresenters [

	self initializeLayout.
	self initializeButtons.
	self initializeRulesTableSelector.
	self initializeMethodsSelector
]

{ #category : #initialization }
RTRuleApplierPresenter >> initializeRulesTableSelector [

	rulesTable := self instantiate: RTRulesSelectorPresenter
]

{ #category : #initialization }
RTRuleApplierPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title translated;
		initialExtent: 750 @ 500;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #actions }
RTRuleApplierPresenter >> manageRulesTableWindow [

	| rulesTableWindow |
	rulesTableWindow := rulesTable window.
	rulesTableWindow presenter class = self class ifTrue: [ 
		^ rulesTable openWithSpec ].
	^ rulesTableWindow isBuilt
		  ifTrue: [ rulesTable closeWindow ]
		  ifFalse: [ rulesTable openWithSpec ]
]

{ #category : #actions }
RTRuleApplierPresenter >> openLoader [

	^ RTRuleLoaderPresenter open
]

{ #category : #actions }
RTRuleApplierPresenter >> runReplace [

	| changes selectedRules |
	selectedRules := rulesTable selectedRules collect: #new.
	changes := RTCustomRuleGenerator
		           obtainChanges: methodsSelectorPresenter selectedMethods
		           forRules: selectedRules.
	^ (RTChangesBrowser changes: changes) open
]

{ #category : #actions }
RTRuleApplierPresenter >> runReplaceOnAllClasses [

	| selectedRules |
	selectedRules := rulesTable selectedRules collect: #new.
	^ self class runReplaceOnAllClasses: selectedRules
]

{ #category : #api }
RTRuleApplierPresenter >> selectedRules: aCollection [

	rulesTable selectedRules: aCollection
]
