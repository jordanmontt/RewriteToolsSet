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
	spec for: #common do: [ 
		spec
			package: 'RewriteTool-Tests';
			package: 'RewriteRuleEditor';
			package: 'RewriteRulesCreator';
			package: 'CustomRewriteRules'
		" Not loading those packages because they are not ready to use.
				package: 'RewriteTool';
				package: 'RewriteToolToRefactor'" ]
]
