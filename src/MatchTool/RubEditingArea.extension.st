Extension { #name : #RubEditingArea }

{ #category : #'*MatchTool' }
RubEditingArea >> beForMatchExpression [
	self editingMode: MatchToolMatchExpressionMode new
]

{ #category : #'*MatchTool' }
RubEditingArea >> beForMatchMethod [
	self editingMode: MatchToolMatchMethodMode new
]

{ #category : #'*MatchTool' }
RubEditingArea >> beForSmalltalkExpression [
	self editingMode: MatchToolCodeExpressionMode new
]

{ #category : #'*MatchTool' }
RubEditingArea >> beForSmalltalkMethod [
	self editingMode: MatchToolCodeMethodMode new
]
