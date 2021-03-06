"
I am a tool that shows all the changes that a rewrite rule will made to a set of classes. I am open by the `RewriteRuleApplierPresenter` tool.

I show all the methods that will be affected and how they will change by the rewrite rule. You can click on any method to see how it will change. If you click the cancel button or close the window, NO changes will be applied.

"
Class {
	#name : #RewriteChangesBrowser,
	#superclass : #SpPresenter,
	#instVars : [
		'#changes',
		'#selectedChanges',
		'#changesTree => SpObservableSlot',
		'#diffView => SpObservableSlot',
		'#buttonCancel => SpObservableSlot',
		'#buttonOk => SpObservableSlot'
	],
	#category : #'RewriteRuleEditor-ChangesBrowser'
}

{ #category : #'instance creation' }
RewriteChangesBrowser class >> changes: aCollection [

	^ self new
		  changes: aCollection;
		  yourself
]

{ #category : #specs }
RewriteChangesBrowser class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: (SpPanedLayout newVertical
				   add: #changesTree;
				   add: #diffView;
				   yourself);
		  add: (SpBoxLayout newHorizontal
				   addLast: #buttonCancel expand: false;
				   addLast: #buttonOk expand: false;
				   yourself)
		  expand: false
		  fill: false
		  padding: 2;
		  yourself
]

{ #category : #actions }
RewriteChangesBrowser >> accept [

	(self okToChange not or: [ selectedChanges isEmptyOrNil ]) ifTrue: [ 
		UIManager default inform: 'No changes to apply.'.
		^ self ].
	[ 
	selectedChanges do: [ :change | 
			RBRefactoryChangeManager instance performChange: change ] ] asJob
		title: 'Refactoring';
		run.
	self closeWindow
]

{ #category : #update }
RewriteChangesBrowser >> buildDiffFor: aChange [

	^ aChange ifNil: [ '' ] ifNotNil: [ 
		  diffView
			  contextClass: aChange changeClass;
			  leftText: aChange oldVersionTextToDisplay;
			  rightText: aChange textToDisplay ]
]

{ #category : #accessing }
RewriteChangesBrowser >> buttonCancel [

	^ buttonCancel
]

{ #category : #accessing }
RewriteChangesBrowser >> buttonOk [

	^ buttonOk
]

{ #category : #accessing }
RewriteChangesBrowser >> changes [

	^ changes
]

{ #category : #accessing }
RewriteChangesBrowser >> changes: anObject [

	changes := anObject.
	selectedChanges := OrderedCollection withAll: changes first changes.
	self updateChanges
]

{ #category : #accessing }
RewriteChangesBrowser >> changesTree [

	^ changesTree
]

{ #category : #actions }
RewriteChangesBrowser >> closeWindow [

	self window close
]

{ #category : #initialization }
RewriteChangesBrowser >> connectPresenters [

	changesTree children: [ :aChange | 
		(aChange isNotNil and: [ aChange changesSize > 1 ])
			ifTrue: [ aChange changes ]
			ifFalse: [ #(  ) ] ].
	buttonCancel action: [ self closeWindow ].
	buttonOk action: [ self accept ]
]

{ #category : #accessing }
RewriteChangesBrowser >> diffView [

	^ diffView
]

{ #category : #initialization }
RewriteChangesBrowser >> initialize [
	changes := #().
	super initialize
]

{ #category : #initialization }
RewriteChangesBrowser >> initializePresenters [

	changesTree := self newTreeTable.
	changesTree
		addColumn: (SpCompositeTableColumn new
				 title: 'Changes';
				 addColumn: ((SpCheckBoxTableColumn evaluated: [ :change | 
							   selectedChanges includes: change ])
						  onActivation: [ :change | selectedChanges add: change ];
						  onDeactivation: [ :change | selectedChanges remove: change ];
						  yourself);
				 addColumn: (SpStringTableColumn evaluated: #nameToDisplay));
		whenActivatedDo: [ :selection | 
		self buildDiffFor: selection selectedItem ];
		activateOnSingleClick.
	diffView := self newDiff showOptions: true.
	buttonCancel := self newButton label: 'Cancel'.
	buttonOk := self newButton label: 'Ok'.
	self focusOrder
		add: changesTree;
		add: diffView;
		add: buttonOk;
		add: buttonCancel
]

{ #category : #initialization }
RewriteChangesBrowser >> initializeWindow: aWindowPresenter [

	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter
		title: 'Changes Browser';
		initialExtent: 70 @ 20 * (fontWidth @ rowHeight)
]

{ #category : #'instance creation' }
RewriteChangesBrowser >> open [

	^ self openWithSpec
]

{ #category : #accessing }
RewriteChangesBrowser >> selectedChanges [
	^ selectedChanges
]

{ #category : #update }
RewriteChangesBrowser >> updateChanges [

	| aCompositeChange |
	aCompositeChange := RBRefactoryChangeManager changeFactory
		                    compositeRefactoryChange.
	changes do: [ :each | aCompositeChange addChange: each ].

	"Later we could filter the shown changes depending on the selected scope"

	changesTree roots: (aCompositeChange whatToDisplayIn: self)
]
