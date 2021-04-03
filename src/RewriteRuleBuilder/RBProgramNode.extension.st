Extension { #name : #RBProgramNode }

{ #category : #'*RewriteRuleBuilder' }
RBProgramNode >> command [
	^ self propertyAt: #command
]

{ #category : #'*RewriteRuleBuilder' }
RBProgramNode >> command: anObject [
	self propertyAt: #command put: anObject
]

{ #category : #'*RewriteRuleBuilder' }
RBProgramNode >> conditionalSelectors [
	| selectors |
	selectors := OrderedCollection new.
	selectors
		add: #ifFalse:;
		add: #ifFalse:ifTrue:;
		add: #ifNil:;
		add: #ifNil:ifNotNil:;
		add: #ifNotNil:;
		add: #ifNotNil:ifNil:;
		add: #ifTrue:;
		add: #ifTrue:ifFalse:;
		add: #or:;
		add: #and:.
	^ selectors
]

{ #category : #'*RewriteRuleBuilder' }
RBProgramNode >> getSequenceParent [
	^ self isSequence
		ifTrue: [ self ]
		ifFalse: [ self parent getSequenceParent ]
]

{ #category : #'*RewriteRuleBuilder' }
RBProgramNode >> initialize [

	super initialize.
	self oldNodes: OrderedCollection new
]

{ #category : #'*RewriteRuleBuilder' }
RBProgramNode >> isInTemporariesList [
	^ false
]

{ #category : #'*RewriteRuleBuilder' }
RBProgramNode >> oldNodes [
	^ self propertyAt: #oldNodes
]

{ #category : #'*RewriteRuleBuilder' }
RBProgramNode >> oldNodes: anObject [
	self propertyAt: #oldNodes put: anObject
]

{ #category : #'*RewriteRuleBuilder' }
RBProgramNode >> optionsForNode [

	| options |
	options := OrderedCollection new.
	self isInTemporariesList ifFalse: [ 
		options add: #( 'Change/Rename' #change ) ].
	self oldNodes ifNotEmpty: [ 
		options add: #( 'Undo on node' #undoOnNode ) ].
	^ options
]
