"
an adapter for MatchTextModel
"
Class {
	#name : #MatchTextAdapter,
	#superclass : #SpMorphicCodeAdapter,
	#category : #'MatchTool-ExtraSpec'
}

{ #category : #private }
MatchTextAdapter >> isForMethod: aBoolean [
	self updateEditingMode
]

{ #category : #private }
MatchTextAdapter >> setEditingModeFor: textArea withBehavior: behavior [


	model isForMatch
		ifTrue: [ 
			model isForMethod
				ifTrue:  [ textArea beForMatchMethod ]
				ifFalse: [ textArea beForMatchExpression ] ]
		ifFalse: [ 
			model isForMethod
				ifTrue:  [ textArea beForSmalltalkMethod ]
				ifFalse: [ textArea beForSmalltalkExpression ] ]
]

{ #category : #actions }
MatchTextAdapter >> updateEditingMode [


	self setEditingModeFor: self widget withBehavior: nil.
]
