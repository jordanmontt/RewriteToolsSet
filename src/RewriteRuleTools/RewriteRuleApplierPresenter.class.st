"
I am a tool that provides a UI for applying a rewrite rule on a certain scope of classes.

In my left column, you can select one or many packages. When you do that, all of their classes will be automatically added to the scope. Also, if you do not want to apply the rewrite rule to all the package's classes, you can select the specific classes on which you want the rewrite rule to be applied.

The methods column shows all the methods the rewrite rule will change. You cannot apply the rewrite rule to a specific method, only to a set of classes.
Remember that multiple selection in supported.

You can open me whit:
`RewriteRuleApplierPresenter open`
"
Class {
	#name : #RewriteRuleApplierPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'selectedClasses',
		'applyOnSelectedClassesButton',
		'applyOnAllClassesButton',
		'openLoaderButton',
		'onlyMyRulesCheckbox',
		'classesListWithFilter',
		'methodsListWithFilter',
		'packagesListWithFilter',
		'rulesTable',
		'openRulesTableButton'
	],
	#category : #'RewriteRuleTools-Applier'
}

{ #category : #accessing }
RewriteRuleApplierPresenter class >> descriptionText [

	^ 'Apply your custom rewrite rules to any packages or classes'
]

{ #category : #accessing }
RewriteRuleApplierPresenter class >> icon [
	^ self iconNamed: #objects
]

{ #category : #api }
RewriteRuleApplierPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #api }
RewriteRuleApplierPresenter class >> runReplaceOnAllClasses: aRule [

	| changes allSystemsClasses |
	allSystemsClasses := RPackage organizer packages flatCollect:
		                     #classes.
	changes := RewriteCustomRuleGenerator
		           obtainChanges: allSystemsClasses
		           forRules: aRule.
	^ (RTChangesBrowser changes: changes) open
]

{ #category : #accessing }
RewriteRuleApplierPresenter class >> title [

	^ 'Rewrite Rule Applier'
]

{ #category : #actions }
RewriteRuleApplierPresenter >> classesChanged [

	selectedClasses := classesListWithFilter listPresenter selectedItems.
	self populateMethodsListWithEnvironmentClasses
]

{ #category : #private }
RewriteRuleApplierPresenter >> classesListWithFilter [

	"This accessors should only be called in the test."

	^ classesListWithFilter
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> connectPresenters [

	packagesListWithFilter listPresenter whenSelectionChangedDo: [ 
		self packagesChanged ].
	classesListWithFilter listPresenter whenSelectionChangedDo: [ 
		self classesChanged ].
	applyOnSelectedClassesButton action: [ self runReplace ].
	applyOnAllClassesButton action: [ self runReplaceOnAllClasses ].
	openLoaderButton action: [ self openLoader ].
	openRulesTableButton action: [ self manageRulesTableWindow ]
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initialize [

	super initialize.
	selectedClasses := OrderedCollection new
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (SpBoxLayout newLeftToRight
					  add: #packagesListWithFilter;
					  add: #classesListWithFilter;
					  add: #methodsListWithFilter;
					  spacing: 5;
					  yourself);
			 addLast: (SpBoxLayout newLeftToRight
					  add: #openRulesTableButton width: 160;
					  addLast: #applyOnSelectedClassesButton;
					  addLast: #applyOnAllClassesButton;
					  addLast: #openLoaderButton;
					  yourself);
			 yourself)
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initializePresenters [

	self initializeLayout.
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
		                    icon: RewriteRuleLoaderPresenter icon.
	rulesTable := self instantiate: RulesSelectorPresenter.
	methodsListWithFilter := self newFilteringList.
	methodsListWithFilter listPresenter
		headerTitle: 'Methods';
		display: [ :item | '    ' , item ].
	packagesListWithFilter := self newFilteringList.
	packagesListWithFilter items: RBBrowserEnvironment new packages.
	packagesListWithFilter listPresenter
		headerTitle: 'Packages';
		display: [ :item | item name ];
		displayIcon: [ self iconNamed: #packageIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		beMultipleSelection.
	classesListWithFilter := self newFilteringList.
	classesListWithFilter listPresenter
		headerTitle: 'Classes';
		display: [ :item | item name ];
		displayIcon: [ :elem | elem systemIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		beMultipleSelection.
	self focusOrder
		add: packagesListWithFilter;
		add: classesListWithFilter;
		add: methodsListWithFilter;
		add: applyOnSelectedClassesButton;
		add: applyOnAllClassesButton;
		add: openLoaderButton
]

{ #category : #initialization }
RewriteRuleApplierPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title translated;
		initialExtent: 750 @ 500;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #actions }
RewriteRuleApplierPresenter >> manageRulesTableWindow [

	| rulesTableWindow |
	rulesTableWindow := rulesTable window.
	rulesTableWindow presenter class = self class ifTrue: [ 
		^ rulesTable openWithSpec ].
	^ rulesTableWindow isBuilt
		  ifTrue: [ rulesTable closeWindow ]
		  ifFalse: [ rulesTable openWithSpec ]
]

{ #category : #private }
RewriteRuleApplierPresenter >> methodsListWithFilter [

	"This accessors should only be called in the test."

	^ methodsListWithFilter
]

{ #category : #actions }
RewriteRuleApplierPresenter >> openLoader [

	^ RewriteRuleLoaderPresenter open
]

{ #category : #actions }
RewriteRuleApplierPresenter >> packagesChanged [

	selectedClasses := packagesListWithFilter listPresenter selectedItems 
		               flatCollect: #classes.
	classesListWithFilter items: selectedClasses.
	classesListWithFilter listPresenter resetListSelection.
	self populateMethodsListWithEnvironmentClasses
]

{ #category : #private }
RewriteRuleApplierPresenter >> packagesListWithFilter [

	"This accessors should only be called in the test."

	^ packagesListWithFilter
]

{ #category : #defaults }
RewriteRuleApplierPresenter >> populateMethodsListWithEnvironmentClasses [

	| methodsInClasses |
	methodsInClasses := selectedClasses flatCollect: #selectors.
	methodsListWithFilter items: methodsInClasses.
	methodsListWithFilter listPresenter resetListSelection
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplace [

	| changes selectedRules |
	selectedRules := rulesTable selectedRules collect: #new.
	changes := RewriteCustomRuleGenerator
		           obtainChanges: selectedClasses
		           forRules: selectedRules.
	^ (RTChangesBrowser changes: changes) open
]

{ #category : #actions }
RewriteRuleApplierPresenter >> runReplaceOnAllClasses [

	| selectedRules |
	selectedRules := rulesTable selectedRules collect: #new.
	^ self class runReplaceOnAllClasses: selectedRules
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> selectedClasses [

	"This accessors should only be called in the test."

	^ selectedClasses
]

{ #category : #accessing }
RewriteRuleApplierPresenter >> selectedClasses: anObject [

	"This accessors should only be called in the test."

	selectedClasses := anObject
]

{ #category : #api }
RewriteRuleApplierPresenter >> selectedRules: aCollection [

	rulesTable selectedRules: aCollection
]
