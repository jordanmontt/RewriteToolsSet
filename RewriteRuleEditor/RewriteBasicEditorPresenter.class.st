"
I am a tool that allows to create and apply custom rewrite rules. I provide a simple GUI that has to code editors: searchFor and replaceWith. Also, I have a mini cheat sheet for the rewrite rules syntax, and some buttons for action.

To run:
RewriteBasicEditorPresenter open

Instance Variables
	searchForEditor:		<SearchForCodePresenter>
	replaceWithEditor:		<ReplaceWithCodePresenter>
	cheatSheet:				<SpTextPresenter>
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
		'cheatSheet',
		'saveButton',
		'loadButton',
		'helpButton',
		'matcherButton',
		'searchForEditor',
		'replaceWithEditor',
		'searchLabel',
		'replaceLabel',
		'ruleName',
		'openApplierButton'
	],
	#category : #'RewriteRuleEditor-BasicEditor'
}

{ #category : #specs }
RewriteBasicEditorPresenter class >> defaultSpec [

	^ SpBoxLayout newHorizontal
		  add: (SpBoxLayout newVertical
				   add: #searchLabel expand: false;
				   add: #searchForEditor
				   expand: true
				   fill: true
				   padding: 2;
				   add: #replaceLabel expand: false;
				   add: #replaceWithEditor
				   expand: true
				   fill: true
				   padding: 2;
				   yourself)
		  expand: true;
		  add: (SpBoxLayout newVertical
				   add: #helpButton expand: false;
				   add: #cheatSheet expand: true;
				   addLast: #matcherButton;
				   addLast: #openApplierButton;
				   addLast: #saveButton;
				   addLast: #loadButton;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : #defaults }
RewriteBasicEditorPresenter class >> icon [
	^ self iconNamed: #workspaceIcon
]

{ #category : #specs }
RewriteBasicEditorPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #initialization }
RewriteBasicEditorPresenter >> connectPresenters [

	loadButton action: [ self openRuleLoader ].
	saveButton action: [ self saveRule ].
	openApplierButton action: [ self openApplier ].
	matcherButton action: [ self openMatchTool ].
	helpButton action: [ self openHelpBrowser ]
]

{ #category : #defaults }
RewriteBasicEditorPresenter >> createRuleClass: aRuleClassName forPackage: aPackageName [

	^ CustomRuleGenerator new
		  searchFor: searchForEditor text;
		  replaceWith: replaceWithEditor text;
		  generateRule: aRuleClassName forPackage: aPackageName
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> helpText [

	^ '` = meta var
			
@ = list

` = recurse into

. = statement

# = literal'
]

{ #category : #initialization }
RewriteBasicEditorPresenter >> initializePresenters [

	searchLabel := self newLabel
		               label: 'Search for:';
		               yourself.
	replaceLabel := self newLabel
		                label: 'Replace with:';
		                yourself.
	cheatSheet := self newText
		              text: self helpText;
		              enabled: false;
		              yourself.
	searchForEditor := self newCode
		                   text: DefaultRule new searchFor;
		                   yourself.
	replaceWithEditor := self newCode
		                     text: DefaultRule new replaceWith;
		                     yourself.
	loadButton := self newButton
		              label: 'Load rule';
		              icon: LoadRewriteRulePresenter icon;
		              yourself.
	saveButton := self newButton
		              label: 'Save rule';
		              icon: (self iconNamed: #smallSaveAs);
		              yourself.
	openApplierButton := self newButton
		                     label: 'Open applier';
		                     icon: RewriteRuleApplierPresenter icon;
		                     yourself.
	matcherButton := self newButton
		                 label: 'Match rule';
		                 icon: MatchToolPresenter icon;
		                 yourself.
	helpButton := self newButton
		              label: 'More help';
		              icon: (self iconNamed: #smallQuestionIcon);
		              yourself.
	self focusOrder
		add: loadButton;
		add: searchForEditor;
		add: replaceWithEditor;
		add: helpButton;
		add: matcherButton;
		add: cheatSheet;
		add: saveButton;
		add: openApplierButton
]

{ #category : #initialization }
RewriteBasicEditorPresenter >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter
		title: 'Rewrite Basic Editor';
		initialExtent: 50 @ 18 * (fontWidth @ rowHeight);
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: 'A simple UI to create Rewrite Rules';
		whenOpenedDo: [ cheatSheet color: self theme baseColor ]
]

{ #category : #actions }
RewriteBasicEditorPresenter >> openApplier [
	^ RewriteRuleApplierPresenter open
]

{ #category : #actions }
RewriteBasicEditorPresenter >> openHelpBrowser [

	^ HelpBrowser openOn: RewriteRulesHelp
]

{ #category : #actions }
RewriteBasicEditorPresenter >> openMatchTool [

	^ MatchToolPresenter open
]

{ #category : #actions }
RewriteBasicEditorPresenter >> openRuleLoader [
	^ LoadRewriteRulePresenter open
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> replaceWithPatternCode [
	^ replaceWithEditor text
]

{ #category : #api }
RewriteBasicEditorPresenter >> replaceWithPatternCode: aCode [
	replaceWithEditor text: aCode
]

{ #category : #api }
RewriteBasicEditorPresenter >> ruleName: aRuleName [

	ruleName := aRuleName
]

{ #category : #defaults }
RewriteBasicEditorPresenter >> ruleNotCreatedAlert [

	UIManager default inform:
		'The name(s) you entered is invalid. Please try again.'
]

{ #category : #defaults }
RewriteBasicEditorPresenter >> ruleSuccessfullyCreatedAlert [
	UIManager default inform: 'The rule was successfully created!'
]

{ #category : #actions }
RewriteBasicEditorPresenter >> saveRule [

	| ruleClassName packageName |
	ruleClassName := UIManager default
		                 request: 'Name of the Rule class: '
		                 initialAnswer: ruleName.
	"If the user pressed the cancel button."
	ruleClassName ifNil: [ ^ self ].
	packageName := UIManager default
		               request: 'Name of the Package: '
		               initialAnswer: 'Custom'.
	"If the user pressed the cancel button."
	packageName ifNil: [ ^ self ].
	(self createRuleClass: ruleClassName forPackage: packageName) 
		ifFalse: [ self ruleNotCreatedAlert ].
	self ruleSuccessfullyCreatedAlert
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> searchForPatternCode [
	^ searchForEditor text
]

{ #category : #api }
RewriteBasicEditorPresenter >> searchForPatternCode: aCode [
	searchForEditor text: aCode
]
