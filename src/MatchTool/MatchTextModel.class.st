"
Extended TextModel to allow special styling including the one for pattern nodes
"
Class {
	#name : #MatchTextModel,
	#superclass : #SpCodePresenter,
	#instVars : [
		'isForMatchHolder',
		'isForMethodHolder'
	],
	#category : #'MatchTool-ExtraSpec'
}

{ #category : #specs }
MatchTextModel class >> defaultSpec [
	<spec: #default>
	^ #(MatchTextAdapter adapt: #(model))
]

{ #category : #initialization }
MatchTextModel >> initialize [
	
	super initialize.
	isForMatchHolder  := false asValueHolder.
	isForMethodHolder := false asValueHolder.
	
	isForMatchHolder whenChangedDo: [ :bool | 
		self changed: #isForMatch: with: { bool } ].
		
	isForMethodHolder whenChangedDo: [ :bool | 
		self changed: #isForMethod: with: { bool } ].
]

{ #category : #setup }
MatchTextModel >> isForMatch [

	^ isForMatchHolder value
]

{ #category : #setup }
MatchTextModel >> isForMatch: aBoolean [

	isForMatchHolder value: aBoolean
]

{ #category : #setup }
MatchTextModel >> isForMethod [

	^ isForMethodHolder value
]

{ #category : #setup }
MatchTextModel >> isForMethod: aBoolean [

	isForMethodHolder value: aBoolean
]

{ #category : #'api-events' }
MatchTextModel >> whenEdited: aBlock [
	"Set a block to perform when the accept block changed"
	
	hasUnacceptedEdits whenChangedDo: [ :val |
		val ifTrue: aBlock value ]
]

{ #category : #'api-events' }
MatchTextModel >> whenIsForMatchChanged: aBlock [
	
	isForMatchHolder whenChangedDo: aBlock
]

{ #category : #'api-events' }
MatchTextModel >> whenIsForMethodChanged: aBlock [
	
	isForMethodHolder whenChangedDo: aBlock
]
