"
The baseline of RewriteTool. This is necessat for install the tool from GitHub.
"
Class {
	#name : #BaselineOfRewriteTool,
	#superclass : #BaselineOf,
	#category : #BaselineOfRewriteTool
}

{ #category : #baselines }
BaselineOfRewriteTool >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'RewriteRuleEditor';
				package: 'RewriteRule-Tests';
				package: 'RewriteRulesCreator';
				package: 'RewriteTool';
				package: 'RewriteToolToRefactor' ]
]
