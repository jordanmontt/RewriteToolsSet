Class {
	#name : #RTBasicEditorPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'rewriteBasicEditor'
	],
	#category : #'RewriteTools-Tests'
}

{ #category : #running }
RTBasicEditorPresenterTest >> setUp [

	super setUp.
	rewriteBasicEditor := RTRuleEditorPresenter new
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testReplaceWithPatternCode [

	rewriteBasicEditor rhs: 'patternCode'.
	self
		assert: rewriteBasicEditor rhs
		equals: 'patternCode'
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testRuleLoadsCorrectly [
	
	| ruleHolder |
	ruleHolder := RTRuleHolder lhs: '`aVar foo' rhs: '`aVar otherFoo'.
	
	rewriteBasicEditor
		lhs: ruleHolder lhs;
		rhs: ruleHolder rhs.

	self	assert: rewriteBasicEditor lhs equals: ruleHolder lhs.
	self	assert: rewriteBasicEditor rhs equals: ruleHolder rhs
]

{ #category : #tests }
RTBasicEditorPresenterTest >> testSearchForPatternCode [

	rewriteBasicEditor lhs: 'patternCode'.
	self
		assert: rewriteBasicEditor lhs
		equals: 'patternCode'
]
