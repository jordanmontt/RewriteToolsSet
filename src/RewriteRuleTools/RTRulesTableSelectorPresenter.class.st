"
I am a presenter that provides a table for showing the rules that are stored in the file system. Also, I provide a text input field for filtering the rules according to their name
"
Class {
	#name : #RTRulesTableSelectorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'rulesTable',
		'filterTextInput'
	],
	#category : #'RewriteRuleTools-Widgets'
}

{ #category : #layout }
RTRulesTableSelectorPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: rulesTable;
		  add: filterTextInput expand: false;
		  yourself
]

{ #category : #actions }
RTRulesTableSelectorPresenter >> filterRules: aText [

	| filteredRules |
	aText ifEmpty: [
		rulesTable items: self getRules.
		^ self ].
	filteredRules := self getRules select: [ :aRuleHolder |
		(aRuleHolder name includesSubstring: aText caseSensitive: false) or: [
			(aRuleHolder lhs includesSubstring: aText caseSensitive: false) or: [
				aRuleHolder rhs includesSubstring: aText caseSensitive: false ] ] ].
	rulesTable items: filteredRules
]

{ #category : #accessing }
RTRulesTableSelectorPresenter >> getRules [

	^ RTDemoRules demoRules
]

{ #category : #initialization }
RTRulesTableSelectorPresenter >> initializeFiltering [

	filterTextInput := self newTextInput.
	filterTextInput
		placeholder: 'Filter...';
		whenTextChangedDo: [ :aText | self filterRules: aText ]
]

{ #category : #initialization }
RTRulesTableSelectorPresenter >> initializePresenters [

	self initializeTable.
	self initializeFiltering
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
		                       evaluated: [ :rule | rule name ].
	lhsTableColumn := SpStringTableColumn
		                  title: 'Search for'
		                  evaluated: [ :rule | rule lhs ].
	rhsTableColumn := SpStringTableColumn
		                  title: 'Replace with'
		                  evaluated: [ :rule | rule rhs ].
	rulesTable
		items: self getRules;
		sortingBlock: [ :a :b |
			a name < b name ];
		addColumn: hashtagTableColumn;
		addColumn: ruleNameTableColumn;
		addColumn: lhsTableColumn;
		addColumn: rhsTableColumn;
		beMultipleSelection
]

{ #category : #api }
RTRulesTableSelectorPresenter >> lhs [

	^ self selectedRules
		ifEmpty: [ '' ]
		ifNotEmpty: [ :f |self selectedRules first lhs ]
]

{ #category : #api }
RTRulesTableSelectorPresenter >> rhs [

	^ self selectedRules
		ifEmpty: [ '' ]
		ifNotEmpty: [ :f |self selectedRules first rhs ]
]

{ #category : #api }
RTRulesTableSelectorPresenter >> selectedRules [

	^ rulesTable selectedItems
]
