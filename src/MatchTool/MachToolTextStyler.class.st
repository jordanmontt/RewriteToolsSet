"
MatchTool Text Styler
"
Class {
	#name : #MachToolTextStyler,
	#superclass : #SHRBTextStyler,
	#instVars : [
		'rbParser'
	],
	#category : #'MatchTool-Styling'
}

{ #category : #setup }
MachToolTextStyler >> beForExpression [

	workspace := true
	
]

{ #category : #setup }
MachToolTextStyler >> beForMatchCode [

	self parser: RBPatternParser
]

{ #category : #setup }
MachToolTextStyler >> beForMethod [

	workspace := nil
	
]

{ #category : #setup }
MachToolTextStyler >> beForSmalltalkCode [

	self parser: RBParser
]

{ #category : #setup }
MachToolTextStyler >> defaultParser [

	^ RBParser
]

{ #category : #private }
MachToolTextStyler >> parse: aText isMethod: isMethod [

	^ isMethod 
		ifTrue: [ 
			self parseFaultyMethod: aText ]	
		ifFalse:[ self parser parseFaultyExpression: aText ].
]

{ #category : #parsing }
MachToolTextStyler >> parseFaultyMethod: aString [ 
	^ [ self parser parseFaultyMethod: aString ]
		on: MessageNotUnderstood
		do: [ :ex | (ex receiver isKindOf: RBParseErrorNode)
				ifTrue: [
					(RBMethodNode selector: #noMethod body: ex receiver) source: aString.
					 ex receiver ]
				ifFalse: [ ex pass ] ]
]

{ #category : #accessing }
MachToolTextStyler >> parser [

	^ rbParser ifNil: [
		rbParser := self defaultParser ]
]

{ #category : #accessing }
MachToolTextStyler >> parser: aParserClass [

	rbParser := aParserClass
]

{ #category : #private }
MachToolTextStyler >> resolveStyleFor: aVariableNode [

	| style |
	style := super resolveStyleFor: aVariableNode.
	"we are working with snippets, we don't want red variables just
	because they were not defined anywhare"
	(style == #invalid or: [ 
	 style == #incompleteIdentifier ])
		ifTrue: [ style := #tempVar ].
	^ style
]

{ #category : #'visiting rb nodes' }
MachToolTextStyler >> visitMessageNode: aMessageNode [

	aMessageNode isPatternNode
		ifTrue: [ self visitPatternMessageNode: aMessageNode ]
		ifFalse: [ super visitMessageNode: aMessageNode ]
]

{ #category : #'visiting rb nodes' }
MachToolTextStyler >> visitMethodNode: aMethodNode [

	aMethodNode isPatternNode
		ifTrue: [ self visitPatternMethodNode: aMethodNode ]
		ifFalse: [ super visitMethodNode: aMethodNode ]
]

{ #category : #'visiting rb nodes' }
MachToolTextStyler >> visitPatternMessageNode: aMessageNode [

	self styleOpenParenthese: aMessageNode.
	aMessageNode selectorParts
		with: aMessageNode keywordsPositions
		do: [ :keyword :position | 
			self
				addStyle: #keyword
				attribute: TextEmphasis underlined
				from: position
				to: position + keyword size - 1 ].
	(aMessageNode isCascaded not or: [ aMessageNode isFirstCascaded ])
		ifTrue: [ self visitNode: aMessageNode receiver ].
	aMessageNode arguments do: [ :each | self visitNode: each ].
	self styleCloseParenthese: aMessageNode

]

{ #category : #'visiting rb nodes' }
MachToolTextStyler >> visitPatternMethodNode: aMethodNode [ 

	aMethodNode comments do: [ :comment |
		self
			addStyle: #comment
			from: comment start
			to: comment stop ].
	aMethodNode arguments do: [ :argument |
		self addStyle: #patternArg forNode: argument ].
	
	aMethodNode selectorParts
		with: aMethodNode keywordsPositions
		do:
			[ :keyword :position | 
			self
				addStyle: #patternKeyword
				attribute: TextEmphasis underlined
				from: position
				to: position + keyword size - 1 ].
	aMethodNode pragmas do: [ :each | self visitNode: each ].
	self visitNode: aMethodNode body
]

{ #category : #'visiting rb nodes' }
MachToolTextStyler >> visitPatternVariableNode: aVariableNode [

	self
		addStyle: #tempVar
		attribute: TextEmphasis underlined
		forNode: aVariableNode
	
]

{ #category : #'visiting rb nodes' }
MachToolTextStyler >> visitVariableNode: aVariableNode [
	
	
	aVariableNode isPatternNode
		ifTrue: [ self visitPatternVariableNode: aVariableNode ]
		ifFalse: [ super visitVariableNode: aVariableNode ]
]
