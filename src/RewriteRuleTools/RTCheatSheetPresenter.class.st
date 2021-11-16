"
I am a cheat sheet for showing help for the rewriting rules
"
Class {
	#name : #RTCheatSheetPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'textPresenter',
		'helpButton'
	],
	#category : #'RewriteRuleTools-Help'
}

{ #category : #accessing }
RTCheatSheetPresenter >> helpText [

	^ '` = meta var

@ = list

` = recurse into

. = statement

# = literal'
]

{ #category : #initialization }
RTCheatSheetPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: helpButton expand: false;
		add: textPresenter;
		yourself)
]

{ #category : #initialization }
RTCheatSheetPresenter >> initializePresenters [

	textPresenter := self newText
		text: self helpText;
		beNotEditable.
	helpButton := self instantiate: (OpenRTHelpBrowserCommand asSpecButtonForContext: self).
	self initializeLayout
	"cheatSheet color: self theme baseColor"
]
