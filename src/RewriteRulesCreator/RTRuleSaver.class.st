"
I save the rules in the disk as ston files. I also load them back to the back in the form of objects.
"
Class {
	#name : #RTRuleSaver,
	#superclass : #Object,
	#category : #'RewriteRulesCreator-Saver'
}

{ #category : #api }
RTRuleSaver class >> allRules [

	^ self customRules , self defaultRules
]

{ #category : #actions }
RTRuleSaver class >> createFile: fileName [

	| file |
	file := (self path , fileName , '.ston') asFileReference.
	file ensureCreateFile.
	^ file
]

{ #category : #api }
RTRuleSaver class >> customRules [

	^ (self stonFilesForPath: self path asFileReference) collect: [ :file | 
		file readStreamDo: [ :stream | STON fromStream: stream ] ]
]

{ #category : #api }
RTRuleSaver class >> defaultRules [

	^ (self stonFilesForPath: self defaultRulesPath asFileReference) collect: [ :file | 
		file readStreamDo: [ :stream | STON fromStream: stream ] ]
]

{ #category : #accessing }
RTRuleSaver class >> defaultRulesPath [

	^ './pharo-local/iceberg/jordanmontt/RewriteToolsSet/default-rewrite-rules'
]

{ #category : #accessing }
RTRuleSaver class >> path [

	^ './pharo-local/custom-rewrite-rules/'
]

{ #category : #actions }
RTRuleSaver class >> stonFilesForPath: fileReference [

	| allFiles stonFiles |
	allFiles := fileReference exists
		ifTrue: [ fileReference files ]
		ifFalse: [ #( ) ].
	stonFiles := allFiles select: [ :each | each basename endsWith: '.ston' ].
	^ stonFiles
]

{ #category : #api }
RTRuleSaver class >> storeRuleOnDisk: aRuleHolder [

	| fileName file |
	fileName := UIManager default
		request: 'Name of the file: '
		initialAnswer: ''.

	"If the user pressed the cancel button"
	(fileName isNil or: [ fileName isEmpty ]) ifTrue: [ 
		UIManager inform: 'You need to specify a name for the file.'.
		^ self ].

	aRuleHolder name: fileName.
	
	file := self createFile: fileName.
	self write: aRuleHolder toFile: file
]

{ #category : #api }
RTRuleSaver class >> storeRuleOnDisk: aRuleHolder name: fileName [

	|  file |
	

	aRuleHolder name: fileName.
	
	file := self createFile: fileName.
	self write: aRuleHolder toFile: file
]

{ #category : #'storing on disk' }
RTRuleSaver class >> write: aRuleHolder toFile: file [

	file writeStreamDo: [ :stream | STON put: aRuleHolder onStream: stream ]
]