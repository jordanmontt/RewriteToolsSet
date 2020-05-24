"
A mini cheat sheet for the Rewrite rules syntax.
"
Class {
	#name : #MiniCheatSheetRewriteRules,
	#superclass : #SpPresenter,
	#instVars : [
		'varLabel',
		'listLabel',
		'recurseLabel',
		'statementLabel',
		'literalLabel'
	],
	#category : #'RewriteTool-BasicTransformation'
}

{ #category : #specs }
MiniCheatSheetRewriteRules class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #varLabel height: self labelHeight;
		add: #listLabel  height: self labelHeight;
		add: #recurseLabel  height: self labelHeight;
		add: #statementLabel  height: self labelHeight;
		add: #literalLabel  height: self labelHeight;
		yourself
]

{ #category : #defaults }
MiniCheatSheetRewriteRules class >> labelHeight [
	^ 30
]

{ #category : #initialization }
MiniCheatSheetRewriteRules >> initializePresenters [
	varLabel := self newLabel
		label: '	` = meta var';
		addStyle: 'bold';
		yourself.
	listLabel := self newLabel
		label: '	@ = list';
		addStyle: 'bold';
		yourself.
	recurseLabel := self newLabel
		addStyle: 'bold';
		label: '	` = recurse into';
		yourself.
	statementLabel := self newLabel
		label: '	. = statement';
		addStyle: 'bold';
		yourself.
	literalLabel := self newLabel
		label: '	# = literal';
		addStyle: 'bold';
		yourself
]
