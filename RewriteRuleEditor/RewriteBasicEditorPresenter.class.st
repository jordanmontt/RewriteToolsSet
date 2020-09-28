"
I am a tool that allows you to create, apply and save custom rewrite rules. To open me: `RewriteBasicEditorPresenter open`

You can write the rewrite rule on searchFor's and replaceWith's editors. When the rewrite rule is written, you can click on 'Open Applier' for open a tool that allows you to apply the rewrite rule to specific classes. Or you just can click on 'Apply on all classes' to apply the rewrite rule to all system's classes.

The Applier only works with saved rules, so remember to save your rule before open it. To apply the rule to all system's classes you do not need to save the rule.

The rule is saved as a subclass of `RBTransformationRule` so the name you enter must be a valid class name.

If you want to edit an already saved rewrite rule, just click on 'Open Loader' and select your rule. When you open me with an already saved rule and click the 'Save rule' button, the name of the rule is entered by default. If you save a rewrite rule with the same name it will be updated.

Click on MatchTool to open a tool that allows you to match your rule with a block of Pharo's code.
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
		'openApplierButton',
		'applyButton'
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
				   addLast: #applyButton;
				   addLast: #openApplierButton;
				   addLast: #saveButton;
				   addLast: #loadButton;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : #defaults }
RewriteBasicEditorPresenter class >> descriptionText [ 

	^ 'A tool to build and apply custom Rewrite Rules.'
]

{ #category : #defaults }
RewriteBasicEditorPresenter class >> icon [
	^ self iconNamed: #workspaceIcon
]

{ #category : #'world menu' }
RewriteBasicEditorPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #RewriteRuleEditor)
		action: [ self open ];
		order: 30;
		parent: #Tools;
		help: self descriptionText;
		icon: self icon
]

{ #category : #specs }
RewriteBasicEditorPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #actions }
RewriteBasicEditorPresenter >> applyOnAllClasses [

	| rewriter rule |
	(UIManager default confirm:
		 'Do you want to apply this rule to all system classes?') ifFalse: [ 
		^ self ].
	rewriter := RBParseTreeRewriter new
		            replace: self searchForPatternCode
		            with: self replaceWithPatternCode;
		            yourself.
	rule := RBTransformationRule new
		        rewriteRule: rewriter;
		        yourself.
	RewriteRuleApplierPresenter runReplaceOnAllClasses: rule
]

{ #category : #initialization }
RewriteBasicEditorPresenter >> connectPresenters [

	loadButton action: [ self openRuleLoader ].
	saveButton action: [ self saveRule ].
	openApplierButton action: [ self openApplier ].
	matcherButton action: [ self openMatchTool ].
	helpButton action: [ self openHelpBrowser ].
	applyButton action: [ self applyOnAllClasses ]
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
		                   text: DefaultRule new lhs;
		                   yourself.
	replaceWithEditor := self newCode
		                     text: DefaultRule new rhs;
		                     yourself.
	loadButton := self newButton
		              label: 'Load a rule';
		              icon: RewriteRuleLoaderPresenter icon;
		              yourself.
	saveButton := self newButton
		              label: 'Save rule';
		              icon: (self iconNamed: #smallSaveAs);
		              yourself.
	openApplierButton := self newButton
		                     label: 'Open Applier';
		                     icon: RewriteRuleApplierPresenter icon;
		                     yourself.
	matcherButton := self newButton
		                 label: 'Match rule';
		                 icon: MatchToolPresenter icon;
		                 yourself.
	applyButton := self newButton
		               label: 'Apply rule';
		               icon: RewriteRuleApplierPresenter icon;
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

	^ MatchToolPresenter new
		  patternCode: searchForEditor text;
		  pharoCode: '';
		  openWithSpec
]

{ #category : #actions }
RewriteBasicEditorPresenter >> openRuleLoader [
	^ RewriteRuleLoaderPresenter open
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> replaceWithPatternCode [
	^ replaceWithEditor text
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> replaceWithPatternCode: aCode [
	replaceWithEditor text: aCode
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> ruleName: aRuleName [

	ruleName := aRuleName
]

{ #category : #actions }
RewriteBasicEditorPresenter >> saveRule [

	^ CustomRuleGenerator new
		  searchFor: searchForEditor text;
		  replaceWith: replaceWithEditor text;
		  storeRule: ruleName
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> searchForPatternCode [
	^ searchForEditor text
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> searchForPatternCode: aCode [
	searchForEditor text: aCode
]
