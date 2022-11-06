"
I am a tool that shows all the changes that a rewrite rule will made to a set of classes. I am open by the `RewriteRuleApplierPresenter` tool.

I show all the methods that will be affected and how they will change by the rewrite rule. You can click on any method to see how it will change. If you click the cancel button or close the window, NO changes will be applied.

"
Class {
	#name : #RTChangesBrowser,
	#superclass : #SpPresenter,
	#instVars : [
		'changes',
		'selectedChanges',
		'changesTree',
		'diffView',
		'buttonCancel',
		'buttonOk'
	],
	#category : #'RewriteRuleTools-ChangesBrowser'
}

{ #category : #'instance creation' }
RTChangesBrowser class >> changes: aCollection [

	^ self new
		changes: aCollection;
		yourself
]

{ #category : #actions }
RTChangesBrowser >> accept [

	(self okToChange not or: [ selectedChanges isEmptyOrNil ]) ifTrue: [ 
		UIManager default inform: 'No changes to apply.'.
		^ self ].

	RTAbstractApplier applyTransformationChanges: selectedChanges.
	
	self closeWindow
]

{ #category : #update }
RTChangesBrowser >> buildDiffFor: aChange [

	^ aChange ifNil: [ '' ] ifNotNil: [ 
		diffView
			contextClass: aChange changeClass;
			leftText: aChange oldVersionTextToDisplay;
			rightText: aChange textToDisplay ]
]

{ #category : #accessing }
RTChangesBrowser >> changes [

	^ changes
]

{ #category : #accessing }
RTChangesBrowser >> changes: anObject [

	changes := anObject.
	selectedChanges := OrderedCollection withAll: changes.
	self updateChanges
]

{ #category : #actions }
RTChangesBrowser >> closeWindow [

	self window close
]

{ #category : #initialization }
RTChangesBrowser >> connectPresenters [

	changesTree children: [ :aChange | 
		(aChange isNotNil and: [ aChange changesSize > 1 ])
			ifTrue: [ aChange changes ]
			ifFalse: [ #(  ) ] ].
	
	buttonCancel action: [ self closeWindow ].
	
	buttonOk action: [ self accept ]
]

{ #category : #initialization }
RTChangesBrowser >> initialize [

	super initialize.
	selectedChanges := #(  ).
	changes := #(  )
]

{ #category : #initialization }
RTChangesBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: (SpPanedLayout newTopToBottom
			add: changesTree;
			add: diffView;
			yourself);
		add: (SpBoxLayout newLeftToRight
			addLast: buttonCancel expand: false;
			addLast: buttonOk expand: false;
			yourself)
		expand: false;
		yourself)
]

{ #category : #initialization }
RTChangesBrowser >> initializePresenters [

	changesTree := self newTreeTable.
	changesTree
		addColumn: (SpCompositeTableColumn new
			title: 'Changes';
			addColumn: ((SpCheckBoxTableColumn evaluated: [ :change | 
				selectedChanges includes: change ])
					onActivation: [ :change | selectedChanges add: change ];
					onDeactivation: [ :change | selectedChanges remove: change ];
					yourself);
			addColumn: (SpStringTableColumn evaluated: [:i | i nameToDisplay]));
		whenActivatedDo: [ :selection | self buildDiffFor: selection selectedItem ];
		activateOnSingleClick.
		
	diffView := self newDiff.
	diffView showOptions: true.
	
	buttonCancel := self newButton.
	buttonCancel label: 'Cancel'.
	
	buttonOk := self newButton.
	buttonOk label: 'Ok'.
	
	self initializeLayout
]

{ #category : #initialization }
RTChangesBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Changes Browser';
		initialExtent: 750 @ 500
]

{ #category : #accessing }
RTChangesBrowser >> selectedChanges [
	^ selectedChanges
]

{ #category : #update }
RTChangesBrowser >> updateChanges [

	| aCompositeChange |
	self flag: 'This is weird. Think about refactoring'.
	aCompositeChange := RBRefactoryChangeManager changeFactory compositeRefactoryChange.
	changes do: [ :each | aCompositeChange addChange: each ].

	"Later we could filter the shown changes depending on the selected scope"
	changesTree roots: (aCompositeChange whatToDisplayIn: self)
]
