"
I am a presenter that allows to select a list of methods.
If you only click on one package, I will return all the methods of all the classes for that package. If you select one class, I will return all the methods of that class. If you select one method, I will only return that method.
I support multiselection for packages, classes and methods.

I can be initialized with a collection of packages `MethodsSelectorPresenter class>>#withPackages:`. If you do not set a collection of packages and only use `MethodsSelectorPresenter new` I will initialize with all Pharo packages by default.

To obtain the selected methods: `MethodsSelectorPresenter>>#selectedMethods`
"
Class {
	#name : #ScopeSelectorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'methodsSelection',
		'toolbar',
		'classesListWithFilterPresenter',
		'packagesListWithFilterPresenter',
		'methodsListWithFilterPresenter',
		'buttonCancelPresenter',
		'buttonOkPresenter'
	],
	#category : #'RewriteRuleTools-Transformer'
}

{ #category : #'instance creation' }
ScopeSelectorPresenter class >> withPackages: aPackagesCollection [

	^ self new initializeWithPackages: aPackagesCollection
]

{ #category : #api }
ScopeSelectorPresenter >> allowMethodSelection [

	methodsSelection := true.

	buttonOkPresenter label: 'Create scope for selected classes'
]

{ #category : #actions }
ScopeSelectorPresenter >> classesChanged [

	self updateSelectionForMethodsPresenter
]

{ #category : #api }
ScopeSelectorPresenter >> doNotAllowMethodSelection [

	methodsSelection := false.

	buttonOkPresenter label: 'Create scope for selected methods'
]

{ #category : #initialization }
ScopeSelectorPresenter >> initializeButtons [

	buttonOkPresenter := self newButton.
	buttonOkPresenter
		iconName: #smallOk;
		label: 'Ok';
		action: [ self scopeEnvironment ].
		
	buttonCancelPresenter := self newButton.
	buttonCancelPresenter
		iconName: #smallCancel;
		label: 'Cancel';
		action: [ self window close ].
		
	toolbar := SpBoxLayout newLeftToRight
		spacing: 5;
		addLast: buttonOkPresenter;
		addLast: buttonCancelPresenter;
		yourself
]

{ #category : #initialization }
ScopeSelectorPresenter >> initializeClassesList [

	classesListWithFilterPresenter := self newFilteringList.
	classesListWithFilterPresenter listPresenter
		headerTitle: 'Classes';
		display: [ :item | item name ];
		displayIcon: [ :elem | elem systemIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		whenSelectionChangedDo: [ :selection | self classesChanged ];
		beMultipleSelection
]

{ #category : #initialization }
ScopeSelectorPresenter >> initializeLayout [

	| listsLayout |
	listsLayout := SpBoxLayout newLeftToRight
		add: packagesListWithFilterPresenter;
		add: classesListWithFilterPresenter;
		add: methodsListWithFilterPresenter;
			spacing: 5;
		yourself.

	self layout: (SpBoxLayout newTopToBottom
		add: listsLayout;
		add: toolbar expand: false;
		yourself)
]

{ #category : #initialization }
ScopeSelectorPresenter >> initializeMethodsList [

	methodsListWithFilterPresenter := self newFilteringList.
	methodsListWithFilterPresenter listPresenter
		headerTitle: 'Methods';
		display: [ :item | '    ' , item selector ];
		sortingBlock: [ :a :b | a selector < b selector ]
]

{ #category : #initialization }
ScopeSelectorPresenter >> initializePackagesList [

	packagesListWithFilterPresenter := self newFilteringList.
	packagesListWithFilterPresenter items: RBBrowserEnvironment new packages.
	packagesListWithFilterPresenter listPresenter
		headerTitle: 'Packages';
		display: [ :item | item name ];
		displayIcon: [ self iconNamed: #packageIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		whenSelectionChangedDo: [ self packagesChanged ];
		beMultipleSelection
]

{ #category : #initialization }
ScopeSelectorPresenter >> initializePresenters [
	
	self initializePackagesList.
	self initializeClassesList.
	self initializeMethodsList.
	self initializeButtons.
	
	self doNotAllowMethodSelection.
	
	self initializeLayout
]

{ #category : #initialization }
ScopeSelectorPresenter >> initializeToolbar [

	buttonOkPresenter := self newButton.
	buttonOkPresenter
		iconName: #smallOk;
		label: 'Ok';
		action: [ self scopeEnvironment ].
		
	buttonCancelPresenter := self newButton.
	buttonCancelPresenter
		iconName: #smallCancel;
		label: 'Cancel';
		action: [ self window close ].
		
	toolbar := SpBoxLayout newLeftToRight
		spacing: 5;
		addLast: buttonOkPresenter;
		addLast: buttonCancelPresenter;
		yourself.
]

{ #category : #api }
ScopeSelectorPresenter >> initializeWithPackages: aPackagesCollection [

	packagesListWithFilterPresenter items: aPackagesCollection
]

{ #category : #actions }
ScopeSelectorPresenter >> packagesChanged [

	self updateSelectionForClassesPresenter.
	
	self updateSelectionForMethodsPresenter
]

{ #category : #api }
ScopeSelectorPresenter >> scopeEnvironment [

	^ RTRBApplier createScopeEnvironmentForClasses: classesListWithFilterPresenter listPresenter selectedItems
]

{ #category : #api }
ScopeSelectorPresenter >> selectedMethods [

	^ methodsListWithFilterPresenter listPresenter selectedItems
		  ifEmpty: [ methodsListWithFilterPresenter items ]
		  ifNotEmpty: [ methodsListWithFilterPresenter listPresenter selectedItems ]
]

{ #category : #actions }
ScopeSelectorPresenter >> updateSelectionForClassesPresenter [

	| selectedClasses classesSet |
	selectedClasses := packagesListWithFilterPresenter listPresenter selectedItems 
		flatCollect: [ :each | each definedClasses ].
	classesSet := selectedClasses asSet.
	classesListWithFilterPresenter items: classesSet asOrderedCollection.
	classesListWithFilterPresenter listPresenter selectItems:  classesSet asOrderedCollection
]

{ #category : #actions }
ScopeSelectorPresenter >> updateSelectionForMethodsPresenter [

	| methodsInTheSelectedClasses methodsSet |
	methodsInTheSelectedClasses := classesListWithFilterPresenter listPresenter
		selectedItems flatCollect: [ :each | each methods].
	methodsSet := methodsInTheSelectedClasses asSet.
	methodsListWithFilterPresenter items: methodsSet asOrderedCollection.

	methodsSelection
		ifTrue: [ methodsListWithFilterPresenter listPresenter selectItems: methodsInTheSelectedClasses ]
		ifFalse: [ methodsListWithFilterPresenter listPresenter resetListSelection ]
]

{ #category : #api }
ScopeSelectorPresenter >> withoutToolbar [

	toolbar := self newNullPresenter.
	
	self initializeLayout
]
