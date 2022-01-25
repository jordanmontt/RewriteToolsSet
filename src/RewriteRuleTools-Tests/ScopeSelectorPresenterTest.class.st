"
A MethodsSelectorPresenterTest is a test class for testing the behavior of MethodsSelectorPresenter
"
Class {
	#name : #ScopeSelectorPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'scopeSelectorPresenter'
	],
	#category : #'RewriteRuleTools-Tests'
}

{ #category : #running }
ScopeSelectorPresenterTest >> setUp [

	super setUp.
	scopeSelectorPresenter := ScopeSelectorPresenter new
]

{ #category : #tests }
ScopeSelectorPresenterTest >> testInitializePresenters [

	| window |
	self
		assertCollection:
		scopeSelectorPresenter packagesFilteringListPresenter items
		hasSameElements: RBBrowserEnvironment new packages.
	window := scopeSelectorPresenter open.
	self assert: window isBuilt.
	window close
]

{ #category : #tests }
ScopeSelectorPresenterTest >> testInitializeWithPackages [

	| newPresenter packages |
	packages := 'Kernel' asPackage asOrderedCollection.
	newPresenter := ScopeSelectorPresenter new initializeWithPackages:
		                packages.
	self
		assertCollection: newPresenter packagesFilteringListPresenter items
		hasSameElements: packages
]

{ #category : #tests }
ScopeSelectorPresenterTest >> testPackagesChanged [

	| selectedPackages |
	scopeSelectorPresenter packagesFilteringListPresenter listPresenter selectIndexes: (1 to: 16).
	
	selectedPackages := scopeSelectorPresenter
		packagesFilteringListPresenter listPresenter selectedItems.
	
	self assert: selectedPackages size equals: 16.

	self
		assertCollection: scopeSelectorPresenter classesFilteringListPresenter listPresenter items
		hasSameElements: (selectedPackages flatCollect: [ :each | each definedClasses]) .
		
	scopeSelectorPresenter classesFilteringListPresenter listPresenter selectIndexes: (15 to: 30).
	self
		assert: scopeSelectorPresenter classesFilteringListPresenter listPresenter selectedItems size
		equals: 16.
	
	"self
		assertCollection: scopeSelectorPresenter methodsFilteringListPresenter listPresenter items
		hasSameElements: scopeSelectorPresenter selectedMethods.
	
	scopeSelectorPresenter methodsFilteringListPresenter listPresenter selectIndexes: (1 to: 5).
	self
		assert: scopeSelectorPresenter methodsFilteringListPresenter listPresenter selectedItems size
		equals: 5.
	
	self assert: scopeSelectorPresenter selectedMethods size equals: 5"
]

{ #category : #tests }
ScopeSelectorPresenterTest >> testSelectedMethods [

	self assertEmpty: scopeSelectorPresenter selectedMethods.
	scopeSelectorPresenter packagesFilteringListPresenter listPresenter 
		selectIndexes: (20 to: 30).
	self assert: scopeSelectorPresenter selectedMethods isNotEmpty
]

{ #category : #tests }
ScopeSelectorPresenterTest >> testWithPackages [

	| newPresenter packages |
	packages := 'Kernel' asPackage asOrderedCollection.
	newPresenter := ScopeSelectorPresenter withPackages: packages.
	self
		assertCollection: newPresenter packagesFilteringListPresenter items
		hasSameElements: packages
]
