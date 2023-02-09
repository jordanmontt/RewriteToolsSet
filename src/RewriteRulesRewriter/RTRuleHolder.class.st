"
I am a class that is used only to store the information of a rule
"
Class {
	#name : #RTRuleHolder,
	#superclass : #Object,
	#instVars : [
		'lhs',
		'rhs',
		'isForMethod',
		'name',
		'pharoCode'
	],
	#category : #'RewriteRulesRewriter-DataStructure'
}

{ #category : #'instance creation' }
RTRuleHolder class >> lhs: lhs rhs: rhs [

	^ self new
		lhs: lhs;
		rhs: rhs;
		yourself
]

{ #category : #'instance creation' }
RTRuleHolder class >> lhs: lhs rhs: rhs isForMethod: isForMethod [

	^ self new
		lhs: lhs;
		rhs: rhs;
		isRuleForMethod: isForMethod;
		yourself
]

{ #category : #'instance creation' }
RTRuleHolder class >> lhs: lhs rhs: rhs isForMethod: isForMethod pharoCode: inputCode [

	^ self new
		lhs: lhs;
		rhs: rhs;
		isRuleForMethod: isForMethod;
		pharoCode: inputCode;
		yourself
]

{ #category : #'instance creation' }
RTRuleHolder class >> lhs: lhs rhs: rhs name: aName [

	^ self new
		lhs: lhs;
		rhs: rhs;
		name: aName;
		yourself
]

{ #category : #'instance creation' }
RTRuleHolder class >> lhs: lhs rhs: rhs pharoCode: aString [

	^ self new
		lhs: lhs;
		rhs: rhs;
		pharoCode: aString;
		yourself
]

{ #category : #initialization }
RTRuleHolder >> initialize [

	super initialize.
	isForMethod := false.
	pharoCode := ''
]

{ #category : #accessing }
RTRuleHolder >> isRuleForMethod [

	^ isForMethod
]

{ #category : #accessing }
RTRuleHolder >> isRuleForMethod: anObject [

	isForMethod := anObject
]

{ #category : #accessing }
RTRuleHolder >> lhs [

	^ lhs
]

{ #category : #accessing }
RTRuleHolder >> lhs: anObject [

	lhs := anObject
]

{ #category : #accessing }
RTRuleHolder >> name [

	^ name
]

{ #category : #accessing }
RTRuleHolder >> name: aString [

	name := aString
]

{ #category : #accessing }
RTRuleHolder >> pharoCode [

	^ pharoCode
]

{ #category : #accessing }
RTRuleHolder >> pharoCode: anObject [

	pharoCode := anObject
]

{ #category : #accessing }
RTRuleHolder >> rhs [

	^ rhs
]

{ #category : #accessing }
RTRuleHolder >> rhs: anObject [

	rhs := anObject
]
