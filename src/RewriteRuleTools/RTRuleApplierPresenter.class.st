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
RTRuleApplierPresenter class >> runReplaceOnAllClasses: aRule [

	| changes allSystemsClasses |
	allSystemsClasses := RPackage organizer packages flatCollect:
		                     #classes.
	changes := RTCustomRuleGenerator
		           obtainChanges: allSystemsClasses
		           forRules: { aRule }.
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

{ #category : #actions }
RTRuleApplierPresenter >> classesChanged [

	selectedClasses := classesListWithFilter listPresenter selectedItems.
	self populateMethodsListWithEnvironmentClasses
]

{ #category : #private }
RTRuleApplierPresenter >> classesListWithFilter [

	"This accessors should only be called in the test."

	^ classesListWithFilter
]

{ #category : #initialization }
RTRuleApplierPresenter >> connectPresenters [

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
RTRuleApplierPresenter >> initialize [

	super initialize.
	selectedClasses := OrderedCollection new
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
RTRuleApplierPresenter >> initializeClassesList [

	classesListWithFilter := self newFilteringList.
	classesListWithFilter listPresenter
		headerTitle: 'Classes';
		display: [ :item | item name ];
		displayIcon: [ :elem | elem systemIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		beMultipleSelection
]

{ #category : #initialization }
RTRuleApplierPresenter >> initializeLayout [

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
RTRuleApplierPresenter >> initializeMethodsList [

	methodsListWithFilter := self newFilteringList.
	methodsListWithFilter listPresenter
		headerTitle: 'Methods';
		display: [ :item | '    ' , item ]
]

{ #category : #initialization }
RTRuleApplierPresenter >> initializePackagesList [

	packagesListWithFilter := self newFilteringList.
	packagesListWithFilter items: RBBrowserEnvironment new packages.
	packagesListWithFilter listPresenter
		headerTitle: 'Packages';
		display: [ :item | item name ];
		displayIcon: [ self iconNamed: #packageIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		beMultipleSelection
]

{ #category : #initialization }
RTRuleApplierPresenter >> initializePresenters [

	self initializeLayout.
	self initializeButtons.
	self initializeRulesTableSelector.
	self initializeMethodsList.
	self initializePackagesList.
	self initializeClassesList.
	self focusOrder
		add: packagesListWithFilter;
		add: classesListWithFilter;
		add: methodsListWithFilter;
		add: applyOnSelectedClassesButton;
		add: applyOnAllClassesButton;
		add: openLoaderButton
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

{ #category : #private }
RTRuleApplierPresenter >> methodsListWithFilter [

	"This accessors should only be called in the test."

	^ methodsListWithFilter
]

{ #category : #actions }
RTRuleApplierPresenter >> openLoader [

	^ RTRuleLoaderPresenter open
]

{ #category : #actions }
RTRuleApplierPresenter >> packagesChanged [

	selectedClasses := packagesListWithFilter listPresenter selectedItems 
		               flatCollect: #classes.
	classesListWithFilter items: selectedClasses.
	classesListWithFilter listPresenter resetListSelection.
	self populateMethodsListWithEnvironmentClasses
]

{ #category : #private }
RTRuleApplierPresenter >> packagesListWithFilter [

	"This accessors should only be called in the test."

	^ packagesListWithFilter
]

{ #category : #defaults }
RTRuleApplierPresenter >> populateMethodsListWithEnvironmentClasses [

	| methodsInClasses |
	methodsInClasses := selectedClasses flatCollect: #selectors.
	methodsListWithFilter items: methodsInClasses.
	methodsListWithFilter listPresenter resetListSelection
]

{ #category : #actions }
RTRuleApplierPresenter >> runReplace [

	| changes selectedRules |
	selectedRules := rulesTable selectedRules collect: #new.
	changes := RTCustomRuleGenerator
		           obtainChanges: selectedClasses
		           forRules: selectedRules.
	^ (RTChangesBrowser changes: changes) open
]

{ #category : #actions }
RTRuleApplierPresenter >> runReplaceOnAllClasses [

	| selectedRules |
	selectedRules := rulesTable selectedRules collect: #new.
	^ self class runReplaceOnAllClasses: selectedRules
]

{ #category : #accessing }
RTRuleApplierPresenter >> selectedClasses [

	"This accessors should only be called in the test."

	^ selectedClasses
]

{ #category : #accessing }
RTRuleApplierPresenter >> selectedClasses: anObject [

	"This accessors should only be called in the test."

	selectedClasses := anObject
]

{ #category : #api }
RTRuleApplierPresenter >> selectedRules: aCollection [

	rulesTable selectedRules: aCollection
]
