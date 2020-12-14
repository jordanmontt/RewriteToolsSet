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
		'openApplierButton',
		'applyButton',
		'builderButton',
		'loadedRule'
	],
	#category : #'RewriteRuleEditor-BasicEditor'
}

{ #category : #specs }
RewriteBasicEditorPresenter class >> defaultSpec [

	| searchForPanel replaceWithPanel |
	searchForPanel := SpBoxLayout newVertical
		                  add: #searchLabel expand: false;
		                  add: #searchForEditor expand: true;
		                  yourself.
	replaceWithPanel := SpBoxLayout newVertical
		                    add: #replaceLabel expand: false;
		                    add: #replaceWithEditor expand: true;
		                    yourself.
	^ SpBoxLayout newHorizontal
		  add: (SpPanedLayout newVertical
				   add: searchForPanel;
				   add: replaceWithPanel;
				   yourself)
		  expand: true;
		  add: (SpBoxLayout newVertical
				   add: #helpButton expand: false;
				   add: #cheatSheet expand: true;
				   add: #saveButton expand: false;
				   add: #openApplierButton expand: false;
				   add: #applyButton expand: false;
				   add: #matcherButton expand: false;
				   add: #builderButton expand: false;
				   add: #loadButton expand: false;
				   yourself)
		  width: 130;
		  yourself
]

{ #category : #accessing }
RewriteBasicEditorPresenter class >> descriptionText [ 

	^ 'A tool to build and apply custom Rewrite Rules.'
]

{ #category : #accessing }
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

{ #category : #accessing }
RewriteBasicEditorPresenter class >> title [

	^ 'Rewrite Basic Editor'
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
	applyButton action: [ self applyOnAllClasses ].
	builderButton action: [ self openBuilder ]
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
RewriteBasicEditorPresenter >> initializeFocusOrder [

	self focusOrder
		add: searchForEditor;
		add: replaceWithEditor;
		add: saveButton;
		add: openApplierButton;
		add: applyButton;
		add: matcherButton;
		add: builderButton;
		add: loadButton
]

{ #category : #initialization }
RewriteBasicEditorPresenter >> initializePresenters [

	searchLabel := self newLabel label: 'Search for:'.
	replaceLabel := self newLabel label: 'Replace with:'.
	cheatSheet := self newText
		              text: self helpText;
		              beNotEditable.
	searchForEditor := self newCode text: DefaultRule new lhs.
	replaceWithEditor := self newCode text: DefaultRule new rhs.
	loadButton := self newButton
		              label: 'Load a rule';
		              icon: RewriteRuleLoaderPresenter icon.
	saveButton := self newButton
		              label: 'Save rule';
		              icon: (self iconNamed: #smallSaveAs).
	openApplierButton := self newButton
		                     label: 'Apply on selection...';
		                     icon: RewriteRuleApplierPresenter icon;
		                     help:
			                     'Open a tool to apply a saved rewrite rule to a selected set of classes.'.
	matcherButton := self newButton
		                 label: 'Match rule';
		                 icon: MatchToolPresenter icon.
	applyButton := self newButton
		               label: 'Apply on all classes';
		               help:
			               'Apply the current rewrite rule that is on this tool to all classes in the system.';
		               icon: RewriteRuleApplierPresenter icon.
	helpButton := self newButton
		              label: 'More help';
		              icon: (self iconNamed: #smallQuestionIcon).
	builderButton := self newButton
		                 label: 'Build rule';
		                 icon: RewriteRuleBuilderPresenter icon.
	self initializeFocusOrder
]

{ #category : #initialization }
RewriteBasicEditorPresenter >> initializeWindow: aWindowPresenter [

	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter
		title: self class title;
		initialExtent: 50 @ 18 * (fontWidth @ rowHeight);
		windowIcon: self class icon;
		aboutText: self class descriptionText;
		whenOpenedDo: [ cheatSheet color: self theme baseColor ]
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> loadedRule: aRule [

	loadedRule := aRule
]

{ #category : #actions }
RewriteBasicEditorPresenter >> openApplier [

	| applier |
	^ loadedRule
		  ifNotNil: [ 
			  applier := RewriteRuleApplierPresenter new.
			  applier rulesDropdown selectItem: loadedRule class.
			  applier openWithSpec ]
		  ifNil: [ RewriteRuleApplierPresenter open ]
]

{ #category : #actions }
RewriteBasicEditorPresenter >> openBuilder [

	^ RewriteRuleBuilderPresenter new
		  lhs: self searchForPatternCode;
		  rhs: self replaceWithPatternCode;
		  inputCode: '';
		  outputCode: '';
		  openWithSpec
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

{ #category : #actions }
RewriteBasicEditorPresenter >> saveRule [

	^ CustomRuleGenerator new
		  searchFor: searchForEditor text;
		  replaceWith: replaceWithEditor text;
		  storeRule: loadedRule className
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> searchForPatternCode [
	^ searchForEditor text
]

{ #category : #accesing }
RewriteBasicEditorPresenter >> searchForPatternCode: aCode [
	searchForEditor text: aCode
]
