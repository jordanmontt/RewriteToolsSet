"
A MethodsSelectorPresenterTest is a test class for testing the behavior of MethodsSelectorPresenter
"
Class {
	#name : #MethodsSelectorPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'methodsSelectorPresenter'
	],
	#category : #'RewriteTools-Tests'
}

{ #category : #running }
MethodsSelectorPresenterTest >> setUp [

	super setUp.
	methodsSelectorPresenter := MethodsSelectorPresenter new
]

{ #category : #tests }
MethodsSelectorPresenterTest >> testInitializePresenters [

	| window |
	self
		assertCollection:
		methodsSelectorPresenter packagesFilteringListPresenter items
		hasSameElements: RBBrowserEnvironment new packages.
	window := methodsSelectorPresenter open.
	self assert: window isBuilt.
	window close
]

{ #category : #tests }
MethodsSelectorPresenterTest >> testInitializeWithPackages [

	| newPresenter packages |
	packages := 'Kernel' asPackage asOrderedCollection.
	newPresenter := MethodsSelectorPresenter new initializeWithPackages:
		                packages.
	self
		assertCollection: newPresenter packagesFilteringListPresenter items
		hasSameElements: packages
]

{ #category : #tests }
MethodsSelectorPresenterTest >> testPackagesChanged [

	| selectedPackages |
	methodsSelectorPresenter packagesFilteringListPresenter listPresenter 
		selectIndexes: (1 to: 16).
	selectedPackages := methodsSelectorPresenter
		                    packagesFilteringListPresenter listPresenter
		                    selectedItems.
	self assert: selectedPackages size equals: 16.
	self
		assertCollection:
			methodsSelectorPresenter classesFilteringListPresenter
				listPresenter items
		hasSameElements: (selectedPackages flatCollect: #classes).
	methodsSelectorPresenter classesFilteringListPresenter listPresenter 
		selectIndexes: (15 to: 30).
	self
		assert:
			methodsSelectorPresenter classesFilteringListPresenter
				listPresenter selectedItems size
		equals: 16.
	self
		assertCollection:
			methodsSelectorPresenter methodsFilteringListPresenter
				listPresenter items
		hasSameElements: methodsSelectorPresenter selectedMethods.
	methodsSelectorPresenter methodsFilteringListPresenter listPresenter 
		selectIndexes: (1 to: 5).
	self
		assert:
			methodsSelectorPresenter methodsFilteringListPresenter
				listPresenter selectedItems size
		equals: 5.
	self assert: methodsSelectorPresenter selectedMethods size equals: 5
]

{ #category : #tests }
MethodsSelectorPresenterTest >> testSelectedMethods [

	self assertEmpty: methodsSelectorPresenter selectedMethods.
	methodsSelectorPresenter packagesFilteringListPresenter listPresenter 
		selectIndexes: (20 to: 30).
	self assert: methodsSelectorPresenter selectedMethods isNotEmpty
]

{ #category : #tests }
MethodsSelectorPresenterTest >> testWithPackages [

	| newPresenter packages |
	packages := 'Kernel' asPackage asOrderedCollection.
	newPresenter := MethodsSelectorPresenter withPackages: packages.
	self
		assertCollection: newPresenter packagesFilteringListPresenter items
		hasSameElements: packages
]
