Extension { #name : #RubShoutStylerDecorator }

{ #category : #'*MatchTool' }
RubShoutStylerDecorator >> beForMatchExpression [
	self styler: self matchToolStyler.
	self styler
		beForMatchCode;
		beForExpression
]

{ #category : #'*MatchTool' }
RubShoutStylerDecorator >> beForMatchMethod [
	self styler: self matchToolStyler.
	self styler
		beForMatchCode;
		beForMethod
]

{ #category : #'*MatchTool' }
RubShoutStylerDecorator >> beForMatchTool [
	self styler: self matchToolStyler
]

{ #category : #'*MatchTool' }
RubShoutStylerDecorator >> beForSmalltalkExpression [
	self styler: self matchToolStyler.
	self styler
		beForSmalltalkCode;
		beForExpression
]

{ #category : #'*MatchTool' }
RubShoutStylerDecorator >> beForSmalltalkMethod [
	self styler: self matchToolStyler.
	self styler
		beForSmalltalkCode;
		beForMethod
]

{ #category : #'*MatchTool' }
RubShoutStylerDecorator >> matchToolStyler [
	^ MchToolTextStyler new view: self; yourself
]
