Class {
	#name : #BasicEditorTest,
	#superclass : #TestCase,
	#instVars : [
		'rewriteBasicEditor'
	],
	#category : #'RewriteRule-Tests'
}

{ #category : #running }
BasicEditorTest >> setUp [
	rewriteBasicEditor := RewriteBasicEditorPresenter new.

	
]

{ #category : #running }
BasicEditorTest >> testSaveDefaultRule [
	rewriteBasicEditor
		createRuleClass: 'TemporaryDefaultRuleForTesting'
		forPackage: 'Test'.
	"The class TemporaryDefaultRuleForTesting is not created yet."
	self
		assert: (Smalltalk globals hasClassNamed: 'TemporaryDefaultRuleForTesting')
]

{ #category : #running }
BasicEditorTest >> testSaveRule [
	rewriteBasicEditor
		searchForCode:
			'`variable1 isNil
	ifTrue: `@block1.
`.Statement1';
		replaceWithCode:
			'`variable1 ifNil: `@block1.
`.Statement1'.
	rewriteBasicEditor
		createRuleClass: 'TemporaryCustomRuleForTesting'
		forPackage: 'Test'.
	"The class TemporaryCustomRuleForTesting is not created yet."
	self
		assert: (Smalltalk globals hasClassNamed: 'TemporaryCustomRuleForTesting')
]
