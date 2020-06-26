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
		assert: (Smalltalk globals includes: TemporaryDefaultRuleForTesting)
]

{ #category : #running }
BasicEditorTest >> testSaveRule [
	rewriteBasicEditor searchFrom: ''.
	rewriteBasicEditor
		createRuleClass: 'TemporaryDefaultRuleForTesting'
		forPackage: 'Test'.
	"The class TemporaryDefaultRuleForTesting is not created yet."
	self
		assert: (Smalltalk globals includes: TemporaryDefaultRuleForTesting)
]
