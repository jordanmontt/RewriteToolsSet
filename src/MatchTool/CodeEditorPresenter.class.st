"
A widget with a title label, code area and a  checkbox to switch for method/expression mode.

On accept of the code area the widjet will parse the code into an ast and store it.

The wideget can operate for both smalltalk code and pattern code.
"
Class {
	#name : #CodeEditorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'titleLabel',
		'methodCheckbox',
		'codeArea',
		'ast',
		'parser'
	],
	#category : #'MatchTool-Presenters'
}

{ #category : #specs }
CodeEditorPresenter class >> adapterNameeeee [
	"This method is original called adapterName. The method was deleted to check some bugs...
	But I will store it just in case.
	^ #MatchTextAdapter"

	
]

{ #category : #specs }
CodeEditorPresenter class >> defaultSpec [
	| buttonsRow |
	buttonsRow := SpBoxLayout newHorizontal
		              add: #titleLabel
		              expand: true
		              fill: true
		              padding: 0;
		              add: #methodCheckbox
		              expand: true
		              fill: true
		              padding: 0;
		              yourself.
	^ SpBoxLayout newVertical
		  add: buttonsRow expand: false;
		  add: #codeArea;
		  yourself
]

{ #category : #'event handling' }
CodeEditorPresenter >> accept: text notifying: notifier [
	[ ast := self parse: text ]
		on: SyntaxErrorNotification
		do: [ :ex | 
			notifier notify: ex errorMessage at: ex location in: ex errorCode.
			^ false ].
	^ true
]

{ #category : #'code area api' }
CodeEditorPresenter >> acceptCode [
	codeArea accept
]

{ #category : #api }
CodeEditorPresenter >> astNode [
	^ ast
]

{ #category : #'code area api' }
CodeEditorPresenter >> beForPatternCode [
	parser := RBPatternParser new
]

{ #category : #'code area api' }
CodeEditorPresenter >> beForPharoCode [
	parser := RBParser new
]

{ #category : #'code area api' }
CodeEditorPresenter >> clearCodeSelection [
	codeArea clearSelection 
]

{ #category : #initialization }
CodeEditorPresenter >> connectPresenters [
	codeArea whenSubmitDo: [ :text :notifier | 
		Halt now.
		self accept: text notifying: notifier ]
]

{ #category : #initialization }
CodeEditorPresenter >> initializePresenters [
	titleLabel := self newLabel.
	titleLabel label: ''.
	methodCheckbox := self newCheckBox.
	methodCheckbox label: 'Method'.
	"codeArea := self instantiate: MatchTextModelPresenter.
	codeArea syntaxHighlight: true."
	codeArea := self newCode
]

{ #category : #testing }
CodeEditorPresenter >> isForMethod [

	^ methodCheckbox state
]

{ #category : #'label api' }
CodeEditorPresenter >> label: aString [
	titleLabel label: aString
]

{ #category : #api }
CodeEditorPresenter >> parse: text [
	^ self isForMethod
		ifTrue: [ self parser parseMethod: text ]
		ifFalse: [ self parser parseExpression: text ]
]

{ #category : #accessing }
CodeEditorPresenter >> parser [
	parser
		ifNil: [ 
			self error:
				'You must a set a parser with methods beForSmalltalkCode or beForPatternCode.
				The parser can be either a RBPatternParser or a RBParser' ]
		ifNotNil: [ ^ parser ]
]

{ #category : #api }
CodeEditorPresenter >> parser: aParser [
	self flag: 'Should not use'.
	parser := aParser
]

{ #category : #'code area api' }
CodeEditorPresenter >> setCodeSelection: anInterval [
	codeArea selectionInterval: anInterval
]

{ #category : #'code area api' }
CodeEditorPresenter >> whenCodeEdited: aBlock [
	codeArea whenTextChangedDo: aBlock
]

{ #category : #'checkbox api' }
CodeEditorPresenter >> whenMethodStateChangedDo: aBlock [

	methodCheckbox whenChangedDo: aBlock
]
