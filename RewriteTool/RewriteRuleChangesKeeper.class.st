"
I am a class that stores the changes that were made in `RewriteRuleBuilderPresenter` panels. Instances of my class are in the undoDict of TransformationRule.
I am used for the functionality ""undo"" and ""redo"".
 
- ast: previous AST of panel
- panel: some panel of `RewriteRuleBuilder`

"
Class {
	#name : #RewriteRuleChangesKeeper,
	#superclass : #Object,
	#instVars : [
		'panel',
		'ast'
	],
	#category : #'RewriteTool-Models'
}

{ #category : #'instance creation' }
RewriteRuleChangesKeeper class >> panel: aPanel ast: anAST [

	^ self new
		  panel: aPanel;
		  ast: anAST;
		  yourself
]

{ #category : #accessing }
RewriteRuleChangesKeeper >> ast [
	^ ast
]

{ #category : #accessing }
RewriteRuleChangesKeeper >> ast: anObject [
	ast := anObject
]

{ #category : #accessing }
RewriteRuleChangesKeeper >> panel [
	^ panel
]

{ #category : #accessing }
RewriteRuleChangesKeeper >> panel: anObject [
	panel := anObject
]
