"
An ActivePolygonMorph is a PolygonMorph that shows a label when mouse is ower.

Instance Variables
	infoText:		<String>

infoText
	- is a text that is shown

"
Class {
	#name : #ActivePolygonMorph,
	#superclass : #PolygonMorph,
	#instVars : [
		'infoText'
	],
	#category : #'RewriteToolToRefactor-Morphic'
}

{ #category : #recategorized }
ActivePolygonMorph >> handlesMouseOver: anEvent [
	^ true
]

{ #category : #accessing }
ActivePolygonMorph >> infoMorph [
	| mainMorph stringMorph |
	mainMorph := BorderedMorph new.
	stringMorph := StringMorph contents: self infoText.
	mainMorph
		color: self theme class baseColor;
		borderColor: self color;
		borderWidth: 2;
		width: stringMorph width + 10;
		addMorphCentered: stringMorph;
		yourself.
	^ mainMorph
]

{ #category : #accessing }
ActivePolygonMorph >> infoText [
	^ infoText
]

{ #category : #accessing }
ActivePolygonMorph >> infoText: aString [
	infoText := aString
]

{ #category : #'event handling' }
ActivePolygonMorph >> mouseEnter: anEvent [
	self addMorphCentered: self infoMorph
]

{ #category : #'event handling' }
ActivePolygonMorph >> mouseLeave: anEvent [
	self removeAllMorphs
]
