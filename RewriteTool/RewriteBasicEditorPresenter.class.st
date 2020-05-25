"
I am a tool that allows to create and apply custom rewrite rules. I provide a simple GUI that has to code editors: searchFor and replaceWith. Also, I have a mini cheat sheet for the rewrite rules syntax, and some buttons for action.

To run:
RewriteBasicEditorPresenter open

Instance Variables
	searchForEditor:		<SearchForCodePresenter>
	replaceWithEditor:		<ReplaceWithCodePresenter>
	cheatSheet:				<MiniCheatSheetRewriteRules>
	applyButton: 			<SpButtonPresenter>
	saveButton: 				<SpButtonPresenter>
	loadButton: 				<SpButtonPresenter>
	
	
searchForEditor
	- The code editor for write the ""search for"" part of the rule.

replaceWithEditor
	- The code editor for write the ""replace with"" part of the rule.

cheatSheet
	- A mini cheat sheet to show the rewrite rules syntax.

applyButton
	- Opens the RewriteBrowserPresenter.

saveButton
	- A button to save the rule.
	
loadButton
	- Opens the LoadRulePresenter.

"
Class {
	#name : #RewriteBasicEditorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'methodCheckBox',
		'applyButton',
		'cheatSheet',
		'saveButton',
		'loadButton',
		'searchForEditor',
		'replaceWithEditor'
	],
	#category : #'RewriteTool-BasicEditor'
}

{ #category : #defaults }
RewriteBasicEditorPresenter class >> buttonHeight [
	^ 40
]

{ #category : #specs }
RewriteBasicEditorPresenter class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add:
			(SpBoxLayout newVertical
				add: #searchForEditor;
				add: #replaceWithEditor;
				yourself);
		add:
			(SpBoxLayout newVertical
				add: #cheatSheet;
				add: #applyButton height: self buttonHeight;
				add: #saveButton height: self buttonHeight;
				add: #loadButton height: self buttonHeight;
				yourself)
			width: 150;
		yourself
]

{ #category : #defaults }
RewriteBasicEditorPresenter class >> icon [
	^ self iconNamed: #workspaceIcon
]

{ #category : #specs }
RewriteBasicEditorPresenter class >> open [
	<script>
	^ self new openWithSpec
]

{ #category : #defaults }
RewriteBasicEditorPresenter class >> padding [
	^ 3
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> applierIcon [
	^ RewriteRuleApplierPresenter icon
]

{ #category : #defaults }
RewriteBasicEditorPresenter >> defaultRule [
	| searchFor replaceWith |
	replaceWith := '| ``@object |
`.@Statement1.
``@object ifNil: [ ^ self ].
`.@Statement1.
`.@Statement2'.
	searchFor := '| ``@object |
`.@Statement1.
``@object ifNotNil: [ `.@Statement1.
`.@Statement2 ]'.
	^ Dictionary new
		at: #searchFor put: searchFor;
		at: #replaceWith put: replaceWith;
		yourself
]

{ #category : #initialization }
RewriteBasicEditorPresenter >> initializePresenters [
	"methodCheckBox := self newCheckBox
		label: 'Method';
		yourself."

	"Method checkbox has no functionality yet"

	cheatSheet := self instantiate: MiniCheatSheetRewriteRules.
	searchForEditor := (self instantiate: SearchForCodePresenter)
		codeSource: (self defaultRule at: #searchFor);
		yourself.
	replaceWithEditor := (self instantiate: ReplaceWithCodePresenter)
		codeSource: (self defaultRule at: #replaceWith);
		yourself.
	loadButton := self newButton
		label: 'Load rule';
		icon: self loadRuleIcon;
		action: [ self openRuleLoader ];
		yourself.
	saveButton := self newButton
		label: 'Save rule';
		icon: (self iconNamed: #smallSaveAs);
		action: [ self saveRule ];
		yourself.
	applyButton := self newButton
		label: 'Apply rules';
		icon: self applierIcon;
		action: [ self openApplier ];
		yourself.
	self focusOrder
		add: loadButton;
		add: searchForEditor;
		add: replaceWithEditor;
		add: methodCheckBox;
		add: saveButton;
		add: applyButton;
		add: cheatSheet
]

{ #category : #initialization }
RewriteBasicEditorPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Rewrite Basic Editor';
		initialExtent: 700 @ 500;
		windowIcon: (self class icon);
		askOkToClose: false;
		aboutText: 'A simple UI to create Rewrite Rules'
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> loadRuleIcon [
	^ LoadRulePresenter icon
]

{ #category : #actions }
RewriteBasicEditorPresenter >> openApplier [
	^ RewriteRuleApplierPresenter open
]

{ #category : #actions }
RewriteBasicEditorPresenter >> openRuleLoader [
	^ LoadRulePresenter open
]

{ #category : #api }
RewriteBasicEditorPresenter >> replaceWithCode: aCode [
	replaceWithEditor codeSource: aCode
]

{ #category : #actions }
RewriteBasicEditorPresenter >> saveRule [
	[ CustomRuleGenerator new
		searchFor: searchForEditor codeSource;
		replaceWith: replaceWithEditor codeSource;
		generateCustomRewriteRule.
	^ true ]
		on: Error
		do: [ :e | self error: 'Oops! ' , e className , '!' ].
	^ false
]

{ #category : #api }
RewriteBasicEditorPresenter >> searchForCode: aCode [
	searchForEditor codeSource: aCode
]
