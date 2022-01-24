"
I am a class that is used only to store the information of a rule
"
Class {
	#name : #RTRuleHolder,
	#superclass : #Object,
	#instVars : [
		'inputCode',
		'outputCode',
		'lhs',
		'rhs',
		'isForMethod',
		'isDemoRule',
		'name'
	],
	#category : #'RewriteRulesRewriter-Saver'
}

{ #category : #accessing }
RTRuleHolder class >> checksClass [
	^ false
]

{ #category : #accessing }
RTRuleHolder class >> checksMethod [
	^ false
]

{ #category : #accessing }
RTRuleHolder class >> checksNode [
	^ false
]

{ #category : #accessing }
RTRuleHolder class >> checksPackage [
	
	^ false
]

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
		isForMethod: isForMethod;
		yourself
]

{ #category : #'instance creation' }
RTRuleHolder class >> lhs: lhs rhs: rhs isForMethod: isForMethod inputCode: inputCode outputCode: outputCode [

	^ self new
		lhs: lhs;
		rhs: rhs;
		isForMethod: isForMethod;
		inputCode: inputCode;
		outputCode: outputCode;
		yourself
]

{ #category : #initialization }
RTRuleHolder >> initialize [

	super initialize.
	isDemoRule := false.
	isForMethod := false.
	inputCode := ''.
	outputCode := ''
]

{ #category : #accessing }
RTRuleHolder >> inputCode [

	^ inputCode
]

{ #category : #accessing }
RTRuleHolder >> inputCode: anObject [

	inputCode := anObject
]

{ #category : #accessing }
RTRuleHolder >> isDemoRule [

	^ isDemoRule
]

{ #category : #accessing }
RTRuleHolder >> isDemoRule: anObject [

	isDemoRule := anObject
]

{ #category : #accessing }
RTRuleHolder >> isForMethod [

	^ isForMethod
]

{ #category : #accessing }
RTRuleHolder >> isForMethod: anObject [

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
RTRuleHolder >> outputCode [

	^ outputCode
]

{ #category : #accessing }
RTRuleHolder >> outputCode: anObject [

	outputCode := anObject
]

{ #category : #accessing }
RTRuleHolder >> rhs [

	^ rhs
]

{ #category : #accessing }
RTRuleHolder >> rhs: anObject [

	rhs := anObject
]
