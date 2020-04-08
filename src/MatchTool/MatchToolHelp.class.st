"
MatchTool is a simple UI for experimenting with the matching functionality of pattern code
"
Class {
	#name : #MatchToolHelp,
	#superclass : #CustomHelp,
	#category : #'MatchTool-Help'
}

{ #category : #accessing }
MatchToolHelp class >> basicPatterns [

^ HelpTopic 
		title: '(`) Basic Pattern Nodes'
		contents: 'Code prefixed with a backtick character (`) defines a pattern node. A pattern node can be a variable or a literal:

	`node asString

that will match message asString sent to any receiver.

It can be a message:

	Smalltalk globals `message

that will match any unary message sent to “Smalltalk globals”.

It can also be a method itself:

	`method
		^ nil

that will match any method which returns nil. '
]

{ #category : #accessing }
MatchToolHelp class >> blockPatterns [

^ HelpTopic 
		title: '(`{ }) Block Pattern Nodes'
		contents: 'These are the most exotic of all the nodes. They match any AST nodes like a list pattern and test it with a block. The syntax is similar to the smalltalk block, but curly braces are used instead of square brackets and as always the whole expression begins with a backtick.

Consider the following example:

	`{ :node | node isVariable and: [ node isGlobal ] } become: nil

this pattern will match a message #become: with an attribute nil, where the receiver is a variable and it is a global variable.


There is also a special case called wrapped block pattern node which has the same syntax and follows a normal pattern node. In this case first the node will be matched based on its pattern, and then passed to the block. For example:

	`#arr `{ :node | node isLiteralArray } asArray

is a simple way to detect expression like “#(1 2 3) asArray”. In this case first #(1 2 3) will be matched by the literal node and then tested by the block.'
		
]

{ #category : #accessing }
MatchToolHelp class >> bookDescription [
	^ 'MatchTool is a simple UI for experimenting with the matching functionality of pattern code'
]

{ #category : #accessing }
MatchToolHelp class >> bookName [
	    ^ 'MatchTool'
]

{ #category : #accessing }
MatchToolHelp class >> issues [

	^ HelpTopic
		title: 'Issues?'
		contents: 'If you found any issues in MatchTool please submit them here: https://github.com/jordanmontt/MatchTool-Spec2/issues'
]

{ #category : #accessing }
MatchToolHelp class >> listPatterns [

^ HelpTopic 
		title: '(`@) List Pattern Nodes'
		contents: 'To have complete flexibility there is the possibility to use an at sign (@) before the name of a pattern node which turns the node into a “list pattern node”. These nodes can match more than a single entity. For example

	`@expr isPatternVariable

will match both messages

	1 isPatternVariable

and

	ast statement first isPatternVariable.

but in the second case `@expr will represent “ast statement first”. These pattern nodes will also match block definitions.


With message and method list nodes one can match any number of keywords and parameters. An expression:

	Smalltalk globals `@message: `@args

will match any message (including) unary sent to “Smalltalk globals” and `@args will be mapped to the list of arguments.
!Disclaimer: you may write an expression with just “args” instead of “`@args”, but following the list pattern grammar makes it easier to read.

Similarly you can match a list of temporary variables:

	`@method: `@args
		| `temp `@temps |

This will match any method with one or more temporary variables and without any statement. The first temporary variable will be mapped to `temp the rest ones — to `@temps.


Finally you can have a list of statements:

	[ `.@Statements.
		`var := `@object ]

this expression will match a block which has an assignment of an expression to a variable as a last statement. It can be preceded by any number of other statement (including 0).


The list patterns does not make any sense for literal nodes i.e. `#@literal.


P.S. In the end it does not matter whether you will write `.@Statement or `@.Statement. But I like to put @ closer to the variable name as the character is larger itself and the name looks nicer this way.'
]

{ #category : #accessing }
MatchToolHelp class >> literalPatterns [

^ HelpTopic 
		title: '(`#) Literal Pattern Nodes'
		contents: 'For variables backtick can be followed by hash to enforce that matched receiver will be a literal:

	`#literal asArray'
]

{ #category : #accessing }
MatchToolHelp class >> namingImportant [

^ HelpTopic 
		title: 'Naming is Important'
		contents: 'The pattern nodes are so that you can match anything in their place. But their naming is also important as the code gets mapped to them by name. For example:

	`block value: `@expression value: `@expression

will match only those “value:value:” messages that have exactly the same expressions as both arguments. It is like that because we used the same pattern variable name.'
]

{ #category : #accessing }
MatchToolHelp class >> pages [
	^#(
		uiExplanation
		patternCodeIntro
		basicPatterns
		literalPatterns
		statementPatterns
		listPatterns
		blockPatterns
		namingImportant
		whatNext
		issues)
]

{ #category : #accessing }
MatchToolHelp class >> patternCodeIntro [

^ HelpTopic 
		title: 'Pattern Code Introduction'
		contents: 'Pattern code is very similar to ordinary Smalltalk code, but allows to specify some “wildcards”. The purpose is fairly simple. Imagine that you have a piece of code

	car isNil ifTrue: [ ^ self ].

You can of course compare it with the same piece of code for equality, but wouldn''t it be cool if you could compare something similar, but ignore the fact that the receiver is named “car”? With pattern rules you can do exactly that. Consider the following code and notice the backtick before car:

	`car isNil ifTrue: [ ^ self ].

Now this expression can match any other expression where “isNil ifTrue: [ ^ self ]” is sent to any variable (or literal). With such power you can find all the usages of “isNil ifTrue:” and replace them with “ifNil”.

The following sections will go over different kinds of wildcards (pattern nodes).'
]

{ #category : #accessing }
MatchToolHelp class >> statementPatterns [

^ HelpTopic 
		title: '(`.) Statement Pattern Nodes'
		contents: 'Backtick can be followed by a period to match statements. For example:

	`var
		ifTrue:  [ `.statement1 ]
		ifFalse: [ `.statement2 ]

will match an “ifTrue:ifFalse:” message send to any variable, where both blocks have only one statement each.'
]

{ #category : #accessing }
MatchToolHelp class >> uiExplanation [

^ HelpTopic 
		title: 'UI Explanation'
		contents: 'MatchTool can be opened from the World Menu > Tools category.
		
The main window consists of 3 columns.

The first column consists of two code areas. The top one should be used to enter a *match code* also known as pattern code, while the bottom one should be used for entering plain Smalltalk code as a *test sample*. Both text areas can be switched into a "method mode" where they will parse the entered text as if it is method, otherwise they expect the entered code to be an expression.

The second column contains **result of matching**, **help button** and the main **execute button** (with a "cmd(ctrl)+enter" shortcut) on top of it. After the button is pressed, both match code and test code are accepted and if there are no errors the matching is performed. MatchTool searches for the match pattern in all the test sample and list the detected matches in the result list. Clicking on the items from the result list highlights the matched interval in the test sample code area and shows the **match map** of the pattern code in the third column.

Match map probably needs more explanation. Imagine you have a pattern

	`item printOn: `@expr

While it will match a test sample

	url printOn: FileStream stdout

the match map list will tell you that <`item> was mapped to <url> while <`@expr> was mapped to <FileStream stdout>.'
]

{ #category : #accessing }
MatchToolHelp class >> whatNext [

^ HelpTopic 
		title: 'What Next?'
		contents: 'At the moment you can create quality rules that use pattern expression to detect and even automatically fix violations. If you are interested in implementing new rules based on the pattern code I recommend you to read the documentation about Renraku, the quality model. Just DoIt:

	HelpBrowser openOn: RenrakuHelp

Especially read: Rules > Creating Rules > Special Rules > ReNodeMatchRule'
]
