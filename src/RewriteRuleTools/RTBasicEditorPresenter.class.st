"
I am a tool that allows you to create, apply and save custom rewrite rules. To open me go to my class side method `open`.

You can write the rewrite rule on searchFor's and replaceWith's editors. When the rewrite rule is written, you can click on 'Open Applier' for open a tool that allows you to apply the rewrite rule to specific classes. Or you just can click on 'Apply on all classes' to apply the rewrite rule to all system's classes.

The Applier only works with saved rules, so remember to save your rule before open it. To apply the rule to all system's classes you do not need to save the rule.

The rule is saved as a subclass of `RBTransformationRule` so the name you enter must be a valid class name.

If you want to edit an already saved rewrite rule, just click on 'Open Loader' and select your rule. When you open me with an already saved rule and click the 'Save rule' button, the name of the rule is entered by default. If you save a rewrite rule with the same name it will be updated.

Click on MatchTool to open a tool that allows you to match your rule with a block of Pharo's code.
"
Class {
	#name : #RTBasicEditorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'cheatSheet',
		'saveButton',
		'loadButton',
		'expressionFinderButton',
		'helpButton',
		'matcherButton',
		'searchForEditor',
		'replaceWithEditor',
		'searchLabel',
		'replaceLabel',
		'openApplierButton',
		'applyButton',
		'builderButton',
		'loadedRule',
		'isMethodCheckbox'
	],
	#category : #'RewriteRuleTools-BasicEditor'
}

{ #category : #accessing }
RTBasicEditorPresenter class >> descriptionText [ 

	^ 'A tool to build and apply custom Rewrite Rules.'
]

{ #category : #accesing }
RTBasicEditorPresenter class >> helpText [

	^ '` = meta var

@ = list

` = recurse into

. = statement

# = literal'
]

{ #category : #accessing }
RTBasicEditorPresenter class >> icon [
	^ self iconNamed: #workspaceIcon
]

{ #category : #'world menu' }
RTBasicEditorPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #RewriteRuleEditor)
		action: [ self open ];
		order: 30;
		parent: #Tools;
		help: self descriptionText;
		icon: self icon
]

{ #category : #specs }
RTBasicEditorPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #accessing }
RTBasicEditorPresenter class >> title [

	^ 'Rewrite Basic Editor'
]

{ #category : #actions }
RTBasicEditorPresenter >> applyOnAllClasses [

	(UIManager default confirm:
		 'Do you want to apply this rule to all system classes?') ifFalse: [ 
		^ self ].
	RTRuleApplierPresenter
		runReplaceWithRuleAsAssociation:
		searchForEditor text -> replaceWithEditor text
		isForMethod: isMethodCheckbox state
]

{ #category : #initialization }
RTBasicEditorPresenter >> connectPresenters [

	loadButton action: [ self openRuleLoader ].
	saveButton action: [ self saveRule ].
	openApplierButton action: [ self openApplier ].
	matcherButton action: [ self openMatchTool ].
	helpButton action: [ self openHelpBrowser ].
	applyButton action: [ self applyOnAllClasses ].
	builderButton action: [ self openBuilder ].
	expressionFinderButton action: [ self openExpressionFinder ]
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializeButtons [

	loadButton := self newButton
		              label: 'Load a rule';
		              icon: RTRuleLoaderPresenter icon.
	saveButton := self newButton
		              label: 'Save rule';
		              icon: (self iconNamed: #smallSaveAs).
	openApplierButton := self newButton.
	openApplierButton
		label: 'Apply on selection...';
		icon: RTRuleApplierPresenter icon;
		help:
			'Open a tool to apply a saved rewrite rule to a selected set of classes.'.
	matcherButton := self newButton
		                 label: 'Match rule';
		                 icon: MatchToolPresenter icon.
	applyButton := self newButton.
	applyButton
		label: 'Apply on all classes';
		help:
			'Apply the current rewrite rule that is on this tool to all classes in the system.';
		icon: RTRuleApplierPresenter icon.
	helpButton := self newButton
		              label: 'More help';
		              icon: (self iconNamed: #smallQuestionIcon).
	builderButton := self newButton
		                 label: 'Build rule';
		                 icon: RewriteRuleBuilderPresenter icon.
	expressionFinderButton := self newButton
		                          label: 'Expression finder';
		                          icon: ExpressionFinderPresenter icon
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializeLayout [

	| searchForPanel replaceWithPanel |
	searchForPanel := SpBoxLayout newVertical
		                  add: 'Search for:' expand: false;
		                  add: #searchForEditor expand: true;
		                  yourself.
	replaceWithPanel := SpBoxLayout newVertical
		                    add: 'Replace with:' expand: false;
		                    add: #replaceWithEditor expand: true;
		                    yourself.
	self layout: (SpBoxLayout newLeftToRight
			 add: (SpPanedLayout newVertical
					  add: searchForPanel;
					  add: replaceWithPanel;
					  yourself)
			 expand: true;
			 add: (SpBoxLayout newTopToBottom
					  add: #isMethodCheckbox expand: false;
					  add: #helpButton expand: false;
					  add: #cheatSheet expand: true;
					  add: #saveButton expand: false;
					  add: #openApplierButton expand: false;
					  add: #applyButton expand: false;
					  add: #expressionFinderButton expand: false;
					  add: #matcherButton expand: false;
					  add: #builderButton expand: false;
					  add: #loadButton expand: false;
					  yourself)
			 width: 130;
			 yourself)
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializeMethodCheckbox [

	isMethodCheckbox := self newCheckBox
		                    label: 'Is rule for method?';
		                    yourself
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializePresenters [

	self initializeLayout.
	self initializeMethodCheckbox.
	self initializeTextCheatSheet.
	self initializeRuleEditors.
	self initializeButtons.
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
RTBasicEditorPresenter >> initializeRuleEditors [

	searchForEditor := self newCode text: DefaultRule new lhs.
	replaceWithEditor := self newCode text: DefaultRule new rhs
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializeTextCheatSheet [

	cheatSheet := self newText
		              text: self class helpText;
		              beNotEditable
]

{ #category : #initialization }
RTBasicEditorPresenter >> initializeWindow: aWindowPresenter [

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

{ #category : #accessing }
RTBasicEditorPresenter >> loadedRule: aRule [

	loadedRule := aRule
]

{ #category : #actions }
RTBasicEditorPresenter >> openApplier [

	| applier |
	^ loadedRule
		  ifNotNil: [ 
			  applier := RTRuleApplierPresenter new.
			  applier selectedRules: { loadedRule class }.
			  applier openWithSpec ]
		  ifNil: [ RTRuleApplierPresenter open ]
]

{ #category : #actions }
RTBasicEditorPresenter >> openBuilder [

	^ RewriteRuleBuilderPresenter new
		  lhs: self searchForPatternCode;
		  rhs: self replaceWithPatternCode;
		  inputCode: '';
		  outputCode: '';
		  openWithSpec
]

{ #category : #actions }
RTBasicEditorPresenter >> openExpressionFinder [

	^ ExpressionFinderPresenter new
		  patternCode: searchForEditor text;
		  openWithSpec
]

{ #category : #actions }
RTBasicEditorPresenter >> openHelpBrowser [

	^ RTRulesHelpPresenter open
]

{ #category : #actions }
RTBasicEditorPresenter >> openMatchTool [

	^ MatchToolPresenter new
		  patternCode: searchForEditor text;
		  pharoCode: '';
		  openWithSpec
]

{ #category : #actions }
RTBasicEditorPresenter >> openRuleLoader [
	^ RTRuleLoaderPresenter open
]

{ #category : #accessing }
RTBasicEditorPresenter >> replaceWithPatternCode [
	^ replaceWithEditor text
]

{ #category : #accessing }
RTBasicEditorPresenter >> replaceWithPatternCode: aCode [
	replaceWithEditor text: aCode
]

{ #category : #actions }
RTBasicEditorPresenter >> saveRule [

	^ RTCustomRuleGenerator new
		  searchFor: searchForEditor text;
		  replaceWith: replaceWithEditor text;
		  storeRule: loadedRule className
		  isForMethod: isMethodCheckbox state
]

{ #category : #accessing }
RTBasicEditorPresenter >> searchForPatternCode [
	^ searchForEditor text
]

{ #category : #accessing }
RTBasicEditorPresenter >> searchForPatternCode: aCode [
	searchForEditor text: aCode
]
