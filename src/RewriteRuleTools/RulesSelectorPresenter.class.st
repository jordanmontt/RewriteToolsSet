Class {
	#name : #RulesSelectorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'#rulesTable => SpObservableSlot',
		'#selectedRules',
		'#onlyMyRulesCheckbox',
		'#toolBar',
		'#selectAllCheckbox'
	],
	#category : #'RewriteRuleTools-Applier'
}

{ #category : #'instance creation' }
RulesSelectorPresenter class >> open [

	<script>
	^ self new openWithSpec
]

{ #category : #api }
RulesSelectorPresenter >> closeWindow [

	self window close
]

{ #category : #initialization }
RulesSelectorPresenter >> connectPresenters [

	onlyMyRulesCheckbox whenChangedDo: [ self customRulesCheckBoxChanged ].
	selectAllCheckbox whenChangedDo: [ :state | 
		self selectAllCheckboxStatusChanged: state ]
]

{ #category : #actions }
RulesSelectorPresenter >> customRulesCheckBoxChanged [

	"The catch exception block is because a Spec bug. When you set an empty collectios as a SpDropListPresenter after being populated with some elements, an error appears."

	onlyMyRulesCheckbox state
		ifTrue: [ 
			[ rulesTable items: RewriteCustomRuleGenerator getOnlyCustomRules ]
				on: Exception
				do: [  ] ]
		ifFalse: [ rulesTable items: RewriteCustomRuleGenerator getAllRules ].
	selectedRules := #(  )
]

{ #category : #initialization }
RulesSelectorPresenter >> initialize [

	super initialize.
	selectedRules := OrderedCollection new
]

{ #category : #initialization }
RulesSelectorPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (SpBoxLayout newLeftToRight
					  add: #selectAllCheckbox;
					  add: #onlyMyRulesCheckbox;
					  yourself)
			 expand: false;
			 add: #rulesTable;
			 add: #toolBar expand: false;
			 yourself)
]

{ #category : #initialization }
RulesSelectorPresenter >> initializePresenters [

	self initializeLayout.
	selectAllCheckbox := self newCheckBox
		                     label: 'Select all';
		                     yourself.
	toolBar := self newToolbar
		           beBoth;
		           addItemRight: (SpToolbarButtonPresenter new
				            icon: (self iconNamed: #smallOk);
				            label: 'Ok';
				            action: [ self window close ];
				            yourself).

	onlyMyRulesCheckbox := self newCheckBox label: 'Only my rules'.
	rulesTable := self newTable.
	rulesTable
		addColumn: ((SpCheckBoxTableColumn
				  title: ' '
				  evaluated: [ :class | selectedRules includes: class ])
				 onActivation: [ :class | selectedRules add: class ];
				 onDeactivation: [ :class | selectedRules remove: class ];
				 width: 20;
				 yourself);
		addColumn: (SpStringTableColumn title: 'Rule name' evaluated: #name);
		addColumn:
		(SpStringTableColumn
			 title: 'Search for'
			 evaluated: [ :e | e new lhs ]);
		addColumn: (SpStringTableColumn
				 title: 'Replace with'
				 evaluated: [ :e | e new rhs ]);
		items: RewriteCustomRuleGenerator getAllRules;
		sortingBlock: [ :a :b | a name < b name ];
		beResizable
]

{ #category : #initialization }
RulesSelectorPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Select Rules';
		initialExtent: 450 @ 300
]

{ #category : #accessing }
RulesSelectorPresenter >> items [

	^ rulesTable items
]

{ #category : #accessing }
RulesSelectorPresenter >> items: aCollection [

	^ rulesTable items: aCollection
]

{ #category : #accessing }
RulesSelectorPresenter >> onlyMyRulesCheckbox [

	^ onlyMyRulesCheckbox
]

{ #category : #actions }
RulesSelectorPresenter >> selectAllCheckboxStatusChanged: state [

	selectedRules := state
		                 ifTrue: [ rulesTable items asOrderedCollection ]
		                 ifFalse: [ #(  ) ].
	^ rulesTable refresh
]

{ #category : #accessing }
RulesSelectorPresenter >> selectedRules [

	^ selectedRules
]

{ #category : #accessing }
RulesSelectorPresenter >> selectedRules: aCollection [

	selectedRules := aCollection
]
