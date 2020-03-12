"
A RewriteRuleChange is class that holds changes that were made in RewriteRuleBuilder panels. Instances of this class are in the undoDict of TransformationRule.

Instance Variables
	ast:		<RBProgramNode>
	panel:		<AbstractPanel>

ast
	- previous AST of panel

panel
	- some panel of RewriteRuleBuilder

"
Class {
	#name : #RewriteRuleChange,
	#superclass : #Object,
	#instVars : [
		'panel',
		'ast'
	],
	#category : #'RewriteTool-Models'
}

{ #category : #'instance creation' }
RewriteRuleChange class >> panel: aPanel ast: anAST [
	^ self new
		panel: aPanel;
		ast: anAST;
		yourself
]

{ #category : #accessing }
RewriteRuleChange >> ast [
	^ ast
]

{ #category : #accessing }
RewriteRuleChange >> ast: anObject [
	ast := anObject
]

{ #category : #accessing }
RewriteRuleChange >> panel [
	^ panel
]

{ #category : #accessing }
RewriteRuleChange >> panel: anObject [
	panel := anObject
]
