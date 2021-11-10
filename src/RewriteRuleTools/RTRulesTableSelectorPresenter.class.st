"
I am a presenter that provides a table for showing the rules that are stored in the file system. Also, I provide a text input field for filtering the rules according to their name
"
Class {
	#name : #RTRulesTableSelectorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'rulesTable',
		'filterTextInput',
		'onlyMyRulesCheckbox'
	],
	#category : #'RewriteRuleTools-Widgets'
}

{ #category : #actions }
RTRulesTableSelectorPresenter >> checkboxChanged [

	^ rulesTable items: self getRules
]

{ #category : #actions }
RTRulesTableSelectorPresenter >> filterRules: aText [

	| filteredRules |
	filteredRules := self getRules select: [ :each | 
		each basenameWithoutExtension asLowercase includesSubstring: aText asLowercase ].
	rulesTable items: filteredRules
]

{ #category : #accessing }
RTRulesTableSelectorPresenter >> getRules [

	^ onlyMyRulesCheckbox state
		  ifTrue: [ RTRuleSaver customRulesAsFileReference ]
		  ifFalse: [ RTRuleSaver allRulesAsFileReference ]
]

{ #category : #initialization }
RTRulesTableSelectorPresenter >> initializeCheckbox [

	onlyMyRulesCheckbox := self newCheckBox.
	onlyMyRulesCheckbox
		label: 'Only custom rules';
		whenChangedDo: [ :state | self checkboxChanged ]
]

{ #category : #initialization }
RTRulesTableSelectorPresenter >> initializeFiltering [

	filterTextInput := self newTextInput.
	filterTextInput
		placeholder: 'Filter...';
		whenTextChangedDo: [ :aText | self filterRules: aText ]
]

{ #category : #initialization }
RTRulesTableSelectorPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: onlyMyRulesCheckbox expand: false;
		add: rulesTable;
		add: filterTextInput expand: false;
		yourself)
]

{ #category : #initialization }
RTRulesTableSelectorPresenter >> initializePresenters [

	self initializeCheckbox.
	self initializeTable.
	self initializeFiltering.
	self initializeLayout
]

{ #category : #initialization }
RTRulesTableSelectorPresenter >> initializeTable [

	| lhsTableColumn ruleNameTableColumn hashtagTableColumn rhsTableColumn |
	rulesTable := self newTable.
	hashtagTableColumn := (SpIndexTableColumn title: '#')
		                      width: 20;
		                      yourself.
	ruleNameTableColumn := SpStringTableColumn
		                       title: 'Rule name'
		                       evaluated: [ :f | 
		                       (self instantiateFileAsObject: f) name ].
	lhsTableColumn := SpStringTableColumn
		                  title: 'Search for'
		                  evaluated: [ :f | 
		                  (self instantiateFileAsObject: f) lhs ].
	rhsTableColumn := SpStringTableColumn
		                  title: 'Replace with'
		                  evaluated: [ :f | 
		                  (self instantiateFileAsObject: f) rhs ].
	rulesTable
		items: self getRules;
		sortingBlock: [ :a :b | 
			a basenameWithoutExtension < b basenameWithoutExtension ];
		addColumn: hashtagTableColumn;
		addColumn: ruleNameTableColumn;
		addColumn: lhsTableColumn;
		addColumn: rhsTableColumn;
		beMultipleSelection
]

{ #category : #defaults }
RTRulesTableSelectorPresenter >> instantiateFileAsObject: aFileReference [

	^ aFileReference readStreamDo: [ :stream | STON fromStream: stream ]
]

{ #category : #api }
RTRulesTableSelectorPresenter >> lhs [

	^ self selectedRules
		ifEmpty: [ '' ]
		ifNotEmpty: [ :f |self selectedRules first lhs ]
]

{ #category : #api }
RTRulesTableSelectorPresenter >> refreshRules [

	rulesTable items: self getRules.
	onlyMyRulesCheckbox state: false
]

{ #category : #api }
RTRulesTableSelectorPresenter >> rhs [

	^ self selectedRules
		ifEmpty: [ '' ]
		ifNotEmpty: [ :f |self selectedRules first rhs ]
]

{ #category : #api }
RTRulesTableSelectorPresenter >> selectedRules [

	^ rulesTable selectedItems collect: [ :each | (self instantiateFileAsObject: each) ]
]

{ #category : #api }
RTRulesTableSelectorPresenter >> selectedRulesAsFileReference [

	^ rulesTable selectedItems
]
