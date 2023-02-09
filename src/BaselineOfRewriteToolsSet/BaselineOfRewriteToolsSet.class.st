"
The baseline of RewriteToolsSet. This is necessat for install the tool from GitHub.
"
Class {
	#name : #BaselineOfRewriteToolsSet,
	#superclass : #BaselineOf,
	#category : #BaselineOfRewriteToolsSet
}

{ #category : #baselines }
BaselineOfRewriteToolsSet >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"spec package: 'RewriteRulesRewriter'.
		spec package: 'RewriteRulesRewriter-Tests' with: [ spec includes: #('RewriteRulesRewriter') ]."
		spec package: 'RewriteRuleTools' with: [ spec includes: #('RewriteRulesRewriter') ].
		spec package: 'RewriteRuleTools-Tests' with: [ spec includes: #('RewriteRuleTools') ] ]
]
