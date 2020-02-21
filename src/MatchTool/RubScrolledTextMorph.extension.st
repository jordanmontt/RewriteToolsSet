Extension { #name : #RubScrolledTextMorph }

{ #category : #'*MatchTool' }
RubScrolledTextMorph >> beForMatchExpression [
    self textArea beForMatchExpression.
    self textArea font: StandardFonts codeFont

]

{ #category : #'*MatchTool' }
RubScrolledTextMorph >> beForMatchMethod [
    self textArea beForMatchMethod.
    self textArea font: StandardFonts codeFont

]

{ #category : #'*MatchTool' }
RubScrolledTextMorph >> beForSmalltalkExpression [
    self textArea beForSmalltalkExpression.
    self textArea font: StandardFonts codeFont

]

{ #category : #'*MatchTool' }
RubScrolledTextMorph >> beForSmalltalkMethod [
    self textArea beForSmalltalkMethod.
    self textArea font: StandardFonts codeFont

]
