"
Extended TextModel to allow special styling including the one for pattern nodes
"
Class {
	#name : #MatchTextModelPresenter,
	#superclass : #SpCodePresenter,
	#instVars : [
		'isForMatchHolder',
		'isForMethodHolder'
	],
	#category : #'MatchTool-ExtraSpec'
}

{ #category : #specs }
MatchTextModelPresenter class >> adapterName [
		^ #MatchTextAdapter

	"^ super adapterName"
]

{ #category : #initialization }
MatchTextModelPresenter >> initialize [
	
	super initialize.
	isForMatchHolder  := false asValueHolder.
	isForMethodHolder := false asValueHolder.
	
	isForMatchHolder whenChangedDo: [ :bool | 
		self changed: #isForMatch: with: { bool } ].
		
	isForMethodHolder whenChangedDo: [ :bool | 
		self changed: #isForMethod: with: { bool } ].
]

{ #category : #setup }
MatchTextModelPresenter >> isForMatch [

	^ isForMatchHolder value
]

{ #category : #setup }
MatchTextModelPresenter >> isForMatch: aBoolean [

	isForMatchHolder value: aBoolean
]

{ #category : #setup }
MatchTextModelPresenter >> isForMethod [

	^ isForMethodHolder value
]

{ #category : #setup }
MatchTextModelPresenter >> isForMethod: aBoolean [

	isForMethodHolder value: aBoolean
]

{ #category : #'api-events' }
MatchTextModelPresenter >> whenEdited: aBlock [
	"Set a block to perform when the accept block changed"
	
	hasUnacceptedEdits whenChangedDo: [ :val |
		val ifTrue: aBlock value ]
]

{ #category : #'api-events' }
MatchTextModelPresenter >> whenIsForMatchChanged: aBlock [
	
	isForMatchHolder whenChangedDo: aBlock
]

{ #category : #'api-events' }
MatchTextModelPresenter >> whenIsForMethodChanged: aBlock [
	
	isForMethodHolder whenChangedDo: aBlock
]
