"
A widget with a title label, code area and a  checkbox to switch for method/expression mode.

On accept of the code area the widjet will parse the code into an ast and store it.

The wideget can operate for both smalltalk code and pattern code.
"
Class {
	#name : #MatchToolSnippetPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'titleLabel',
		'methodCheckbox',
		'codeArea',
		'ast'
	],
	#category : #'MatchTool-Presenters'
}

{ #category : #specs }
MatchToolSnippetPresenter class >> defaultSpec [
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
MatchToolSnippetPresenter >> accept [

	codeArea accept
]

{ #category : #'event handling' }
MatchToolSnippetPresenter >> accept: text notifying: notifier [
	[ ast := self parse: text ]
		on: SyntaxErrorNotification
		do: [ :ex | 
			notifier notify: ex errorMessage at: ex location in: ex errorCode.
			^ false ]
]

{ #category : #accessing }
MatchToolSnippetPresenter >> astNode [

	^ ast
]

{ #category : #setup }
MatchToolSnippetPresenter >> beForPatternCode [

	self isForPatternCode: true
]

{ #category : #'code area api' }
MatchToolSnippetPresenter >> clearCodeSelection [
	codeArea clearSelection 
]

{ #category : #accessing }
MatchToolSnippetPresenter >> codeArea [
	^ codeArea
]

{ #category : #initialization }
MatchToolSnippetPresenter >> connectPresenters [
	methodCheckbox whenChangedDo: [ :bool | codeArea isForMethod: bool ].
	codeArea
		acceptBlock:
			[ :text :notifier | self accept: text notifying: notifier ]
]

{ #category : #'code area api' }
MatchToolSnippetPresenter >> hasUnacceptedEdits [
	^ codeArea hasUnacceptedEdits
]

{ #category : #initialization }
MatchToolSnippetPresenter >> initializePresenters [
	
	titleLabel := self newLabel.
	methodCheckbox := self newCheckBox.
	codeArea := self instantiate: MatchTextModel.
	
	titleLabel label: self title.
	methodCheckbox label: 'Method'.
]

{ #category : #setup }
MatchToolSnippetPresenter >> isForMethod [

	^ methodCheckbox state
]

{ #category : #setup }
MatchToolSnippetPresenter >> isForMethod: aBool [

	methodCheckbox state: aBool
]

{ #category : #setup }
MatchToolSnippetPresenter >> isForPatternCode [

	^ codeArea isForMatch
]

{ #category : #setup }
MatchToolSnippetPresenter >> isForPatternCode: aBoolean [

	codeArea isForMatch: aBoolean
]

{ #category : #'code area api' }
MatchToolSnippetPresenter >> label: aString [
	titleLabel label: aString
]

{ #category : #accessing }
MatchToolSnippetPresenter >> methodCheckbox [
	^ methodCheckbox
]

{ #category : #parsing }
MatchToolSnippetPresenter >> parse: text [

	^ self isForMethod
		ifTrue: [ self parser parseMethod: text ]
		ifFalse: [ self parser parseExpression: text ]

]

{ #category : #parsing }
MatchToolSnippetPresenter >> parser [

	^ self isForPatternCode
		ifTrue: [ RBPatternParser ]
		ifFalse: [ RBParser ]
]

{ #category : #'code area api' }
MatchToolSnippetPresenter >> setCodeSelection: anInterval [
	codeArea selectionInterval: anInterval
]

{ #category : #accessing }
MatchToolSnippetPresenter >> titleLabel [
	^ titleLabel
]

{ #category : #'code area api' }
MatchToolSnippetPresenter >> whenCodeEdited: aBlock [
	codeArea whenTextChangedDo: aBlock
]

{ #category : #'checkbox api' }
MatchToolSnippetPresenter >> whenMethodActivatedDo: aBlock [

	methodCheckbox whenActivatedDo: aBlock
]

{ #category : #'checkbox api' }
MatchToolSnippetPresenter >> whenMethodDeactivatedDo: aBlock [

	methodCheckbox whenDeactivatedDo: aBlock
]

{ #category : #'checkbox api' }
MatchToolSnippetPresenter >> whenMethodStateChangedDo: aBlock [

	methodCheckbox whenChangedDo: aBlock
]
