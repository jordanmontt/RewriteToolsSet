"
I save the rules in the disk as ston files. I also load them back to the back in the form of objects.
"
Class {
	#name : #RTRuleSaver,
	#superclass : #Object,
	#classVars : [
		'PathToStoreRules'
	],
	#category : #'RewriteRulesRewriter-Saver'
}

{ #category : #'api - objects' }
RTRuleSaver class >> allRules [

	^ self customRules , self defaultRules
]

{ #category : #'api - file reference' }
RTRuleSaver class >> allRulesAsFileReference [

	^ self customRulesAsFileReference , self defaultRulesAsFileReference
]

{ #category : #actions }
RTRuleSaver class >> createFile: fileName [

	| file |
	file := (self pathToStoreRules , fileName , '.ston') asFileReference.
	file ensureCreateFile.
	^ file
]

{ #category : #'api - objects' }
RTRuleSaver class >> customRules [

	^ self customRulesAsFileReference collect: [ :file | 
		file readStreamDo: [ :stream | STON fromStream: stream ] ]
]

{ #category : #'api - file reference' }
RTRuleSaver class >> customRulesAsFileReference [

	^ (self stonFilesForPath: self pathToStoreRules asFileReference)
]

{ #category : #'api - objects' }
RTRuleSaver class >> defaultRules [

	^ self defaultRulesAsFileReference collect: [ :file | 
		file readStreamDo: [ :stream | STON fromStream: stream ] ]
]

{ #category : #'api - file reference' }
RTRuleSaver class >> defaultRulesAsFileReference [

	^ (self stonFilesForPath: self defaultRulesPath asFileReference)
]

{ #category : #accessing }
RTRuleSaver class >> defaultRulesPath [

	^ './pharo-local/iceberg/jordanmontt/RewriteToolsSet/default-rewrite-rules'
]

{ #category : #accessing }
RTRuleSaver class >> pathToStoreRules [

	^ PathToStoreRules ifNil: [ PathToStoreRules := './pharo-local/custom-rewrite-rules/' ]
]

{ #category : #accessing }
RTRuleSaver class >> pathToStoreRules: aString [

	PathToStoreRules := aString
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

{ #category : #'api - store' }
RTRuleSaver class >> storeRuleOnDisk: aRuleHolder [

	| fileName |
	fileName := UIManager default
		request: 'Name of the file: '
		initialAnswer: ''.

	"If the user pressed the cancel button"
	(fileName isNil or: [ fileName isEmpty ]) ifTrue: [ 
		UIManager inform: 'You need to specify a name for the file.'.
		^ self ].
	
	^ self storeRuleOnDisk: aRuleHolder name: fileName
]

{ #category : #'api - store' }
RTRuleSaver class >> storeRuleOnDisk: aRuleHolder name: fileName [

	| file |
	aRuleHolder name: fileName.
	
	file := self createFile: fileName.
	^ self write: aRuleHolder toFile: file
]

{ #category : #'storing on disk' }
RTRuleSaver class >> write: aRuleHolder toFile: file [

	file writeStreamDo: [ :stream | STON put: aRuleHolder onStream: stream ].
	^ file
]
