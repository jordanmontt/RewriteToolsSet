Extension { #name : #RubEditingArea }

{ #category : #'*MatchTool' }
RubEditingArea >> beForMatchExpression [
	self editingMode: MchToolMatchExpressionMode new
]

{ #category : #'*MatchTool' }
RubEditingArea >> beForMatchMethod [
	self editingMode: MchToolMatchMethodMode new
]

{ #category : #'*MatchTool' }
RubEditingArea >> beForSmalltalkExpression [
	self editingMode: MchToolCodeExpressionMode new
]

{ #category : #'*MatchTool' }
RubEditingArea >> beForSmalltalkMethod [
	self editingMode: MchToolCodeMethodMode new
]
