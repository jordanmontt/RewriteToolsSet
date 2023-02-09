Class {
	#name : #RTRuleLoaderPresenterTest,
	#superclass : #RTAbstractToolTest,
	#instVars : [
		'ruleLoader'
	],
	#category : #'RewriteRuleTools-Tests-RuleLoader'
}

{ #category : #running }
RTRuleLoaderPresenterTest >> setUp [

	super setUp.
	ruleLoader := RTRuleLoaderPresenter new
]

{ #category : #accessing }
RTRuleLoaderPresenterTest >> toolClass [

	^ RTRuleLoaderPresenter
]
