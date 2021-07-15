"
I am a presenter shows 3 lists: one of packages, one for classes and the last one for methods. I return a collection with the selected methods. If none method was selected I will return all the methods of the current packages or classes selected.
For example, if you only click on one package, I will return all the methods of all the classes for that package. If you select one class, I will return all the methods of that class. If you select one method, I will only return that method.
I support multiselection of packages, classes and methods.

To obtain the selected methods: `MethodsSelectorPresenter>>#selectedMethods`
"
Class {
	#name : #MethodsSelectorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'classesListWithFilter',
		'methodsListWithFilter',
		'packagesListWithFilter'
	],
	#category : #'RewriteRuleTools-Applier'
}

{ #category : #'instance creation' }
MethodsSelectorPresenter class >> withPackages: aPackagesCollection [

	^ self new initializeWithPackages: aPackagesCollection
]

{ #category : #actions }
MethodsSelectorPresenter >> classesChanged [

	| classesMethods |
	classesMethods := classesListWithFilter listPresenter selectedItems 
		                  flatCollect: #methods.
	methodsListWithFilter items: classesMethods.
	methodsListWithFilter listPresenter resetListSelection
]

{ #category : #initialization }
MethodsSelectorPresenter >> initializeClassesList [

	classesListWithFilter := self newFilteringList.
	classesListWithFilter listPresenter
		headerTitle: 'Classes';
		display: [ :item | item name ];
		displayIcon: [ :elem | elem systemIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		whenSelectionChangedDo: [ :selection | self classesChanged ];
		beMultipleSelection
]

{ #category : #actions }
MethodsSelectorPresenter >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 add: #packagesListWithFilter;
			 add: #classesListWithFilter;
			 add: #methodsListWithFilter;
			 spacing: 5;
			 yourself)
]

{ #category : #initialization }
MethodsSelectorPresenter >> initializeMethodsList [

	methodsListWithFilter := self newFilteringList.
	methodsListWithFilter listPresenter
		headerTitle: 'Methods';
		display: [ :item | '    ' , item selector ];
		sortingBlock: [ :a :b | a selector < b selector ];
		beMultipleSelection
]

{ #category : #initialization }
MethodsSelectorPresenter >> initializePackagesList [

	packagesListWithFilter := self newFilteringList.
	packagesListWithFilter items: RBBrowserEnvironment new packages.
	packagesListWithFilter listPresenter
		headerTitle: 'Packages';
		display: [ :item | item name ];
		displayIcon: [ self iconNamed: #packageIcon ];
		sortingBlock: [ :a :b | a name < b name ];
		whenSelectionChangedDo: [ self packagesChanged ];
		beMultipleSelection
]

{ #category : #initialization }
MethodsSelectorPresenter >> initializePresenters [

	self initializePackagesList.
	self initializeClassesList.
	self initializeMethodsList.
	self initializeLayout
]

{ #category : #'api - initialization' }
MethodsSelectorPresenter >> initializeWithPackages: aPackagesCollection [

	packagesListWithFilter items: aPackagesCollection
]

{ #category : #actions }
MethodsSelectorPresenter >> packagesChanged [

	| selectedClasses classesMethods |
	selectedClasses := packagesListWithFilter listPresenter selectedItems 
		                   flatCollect: #classes.
	classesListWithFilter items: selectedClasses.
	classesListWithFilter listPresenter resetListSelection.
	classesMethods := selectedClasses flatCollect: #methods.
	methodsListWithFilter items: classesMethods.
	methodsListWithFilter listPresenter resetListSelection
]

{ #category : #'api - accessing' }
MethodsSelectorPresenter >> selectedMethods [

	^ methodsListWithFilter listPresenter selectedItems
		  ifEmpty: [ methodsListWithFilter items ]
		  ifNotEmpty: [ methodsListWithFilter listPresenter selectedItems ]
]
