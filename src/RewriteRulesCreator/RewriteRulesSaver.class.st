Class {
	#name : #RewriteRulesSaver,
	#superclass : #Object,
	#category : #'RewriteRulesCreator-Saver'
}

{ #category : #actions }
RewriteRulesSaver class >> createFile: fileName [

	| file |
	file := (self class path , fileName , '.ston') asFileReference.
	file ensureCreateFile.
	^ file
]

{ #category : #accessing }
RewriteRulesSaver class >> path [

	^ './pharo-local/queries-browser-saved-queries/'
]

{ #category : #api }
RewriteRulesSaver class >> saveRuleOnDisk: aRuleHolder [

	| fileName file |
	fileName := UIManager default
		request: 'Name of the file: '
		initialAnswer: ''.

	"If the user pressed the cancel button"
	(fileName isNil or: [ fileName isEmpty ]) ifTrue: [ 
		UIManager inform: 'You need to specify a name for the file.'.
		^ self ].

	file := self createFile: fileName.
	self write: aRuleHolder toFile: file
]

{ #category : #api }
RewriteRulesSaver class >> stonFiles [

	| fileReference allFiles stonFiles |
	fileReference := self path asFileReference.
	allFiles := fileReference exists
		ifTrue: [ fileReference files ]
		ifFalse: [ #( ) ].
	stonFiles := allFiles select: [ :each | each basename endsWith: '.ston' ].
	^ stonFiles
]

{ #category : #'storing on disk' }
RewriteRulesSaver class >> write: aRuleHolder toFile: file [

	file writeStreamDo: [ :stream | STON put: aRuleHolder onStream: stream ]
]
