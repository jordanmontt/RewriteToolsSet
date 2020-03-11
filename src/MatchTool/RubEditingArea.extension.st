Extension { #name : #RubEditingArea }

{ #category : #'*MatchTool' }
RubEditingArea >> beForMatchExpression [
	self editingMode: MachToolMatchExpressionMode new
]

{ #category : #'*MatchTool' }
RubEditingArea >> beForMatchMethod [
	self editingMode: MachToolMatchMethodMode new
]

{ #category : #'*MatchTool' }
RubEditingArea >> beForSmalltalkExpression [
	self editingMode: MachToolCodeExpressionMode new
]

{ #category : #'*MatchTool' }
RubEditingArea >> beForSmalltalkMethod [
	self editingMode: MachToolCodeMethodMode new
]
