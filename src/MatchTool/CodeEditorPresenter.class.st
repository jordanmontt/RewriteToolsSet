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
CodeEditorPresenter class >> adapterName [
		^ #MatchTextAdapter
]

{ #category : #specs }
CodeEditorPresenter class >> defaultSpec [
	| buttonsRow |
	buttonsRow := SpBoxLayout newHorizontal
		add: #titleLabel width: 100;
		add: #methodCheckbox width: 100;
		yourself.
	^ SpBoxLayout newVertical
		add: buttonsRow height: 30;
		add: #codeArea;
		yourself.
]

{ #category : #'code area api' }
CodeEditorPresenter >> accept [

	codeArea accept
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

{ #category : #api }
CodeEditorPresenter >> astNode [
	^ ast
]

{ #category : #'code area api' }
CodeEditorPresenter >> clearCodeSelection [
	codeArea clearSelection 
]

{ #category : #initialization }
CodeEditorPresenter >> connectPresenters [
	codeArea
		acceptBlock: [ :text :notifier | self accept: text notifying: notifier ]
]

{ #category : #'code area api' }
CodeEditorPresenter >> hasUnacceptedEdits [
	^ codeArea hasUnacceptedEdits
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
		ifNil: [ self
				error:
					'You must a set a parser. It can be either a RBPatternParser or a RBParser' ]
		ifNotNil: [ ^ parser ]
]

{ #category : #api }
CodeEditorPresenter >> parser: aParser [
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
