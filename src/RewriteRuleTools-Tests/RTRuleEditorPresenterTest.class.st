Class {
	#name : #RTRuleEditorPresenterTest,
	#superclass : #RTAbstractToolTest,
	#instVars : [
		'rewriteBasicEditor'
	],
	#category : #'RewriteRuleTools-Tests-BasicEditor'
}

{ #category : #running }
RTRuleEditorPresenterTest >> setUp [

	super setUp.
	rewriteBasicEditor := RTRuleEditorPresenter new
]

{ #category : #tests }
RTRuleEditorPresenterTest >> testReplaceWithPatternCode [

	rewriteBasicEditor rhs: 'patternCode'.
	self
		assert: rewriteBasicEditor rhs
		equals: 'patternCode'
]

{ #category : #tests }
RTRuleEditorPresenterTest >> testRuleLoadsCorrectly [
	
	| ruleHolder |
	ruleHolder := RTRuleHolder lhs: '`aVar foo' rhs: '`aVar otherFoo'.
	
	rewriteBasicEditor
		lhs: ruleHolder lhs;
		rhs: ruleHolder rhs.

	self	assert: rewriteBasicEditor lhs equals: ruleHolder lhs.
	self	assert: rewriteBasicEditor rhs equals: ruleHolder rhs
]

{ #category : #tests }
RTRuleEditorPresenterTest >> testSearchForPatternCode [

	rewriteBasicEditor lhs: 'patternCode'.
	self
		assert: rewriteBasicEditor lhs
		equals: 'patternCode'
]

{ #category : #accessing }
RTRuleEditorPresenterTest >> toolClass [

	^ RTRuleEditorPresenter
]
