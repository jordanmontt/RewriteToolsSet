Class {
	#name : #RewriteRulesHolder,
	#superclass : #Object,
	#instVars : [
		'inputCode',
		'outputCode',
		'lhs',
		'rhs',
		'isForMethod',
		'isDemoRule'
	],
	#category : #'RewriteRulesCreator-Saver'
}

{ #category : #'instance creation' }
RewriteRulesHolder class >> lhs: lhs rhs: rhs isForMethod: isForMethod [

	^ self new
		lhs: lhs;
		rhs: rhs;
		isForMethod: isForMethod
]

{ #category : #'instance creation' }
RewriteRulesHolder class >> lhs: lhs rhs: rhs isForMethod: isForMethod inputCode: inputCode outputCode: outputCode [

	^ self new
		lhs: lhs;
		rhs: rhs;
		isForMethod: isForMethod;
		inputCode: inputCode;
		outputCode: outputCode
]

{ #category : #initialization }
RewriteRulesHolder >> initialize [

	super initialize.
	isDemoRule := false.
	inputCode := ''.
	outputCode := ''
]

{ #category : #accessing }
RewriteRulesHolder >> inputCode [

	^ inputCode
]

{ #category : #accessing }
RewriteRulesHolder >> inputCode: anObject [

	inputCode := anObject
]

{ #category : #accessing }
RewriteRulesHolder >> isDemoRule [

	^ isDemoRule
]

{ #category : #accessing }
RewriteRulesHolder >> isDemoRule: anObject [

	isDemoRule := anObject
]

{ #category : #accessing }
RewriteRulesHolder >> isForMethod [

	^ isForMethod
]

{ #category : #accessing }
RewriteRulesHolder >> isForMethod: anObject [

	isForMethod := anObject
]

{ #category : #accessing }
RewriteRulesHolder >> lhs [

	^ lhs
]

{ #category : #accessing }
RewriteRulesHolder >> lhs: anObject [

	lhs := anObject
]

{ #category : #accessing }
RewriteRulesHolder >> outputCode [

	^ outputCode
]

{ #category : #accessing }
RewriteRulesHolder >> outputCode: anObject [

	outputCode := anObject
]

{ #category : #accessing }
RewriteRulesHolder >> rhs [

	^ rhs
]

{ #category : #accessing }
RewriteRulesHolder >> rhs: anObject [

	rhs := anObject
]
