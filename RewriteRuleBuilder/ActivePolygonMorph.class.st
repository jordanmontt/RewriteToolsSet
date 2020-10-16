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
	#category : #'RewriteRuleBuilder-Morphic'
}

{ #category : #morphic }
ActivePolygonMorph class >> createArrowMorph: aClass [

	| morph |
	morph := aClass
		         vertices: { 
				         (0 @ 80).
				         (150 @ 80).
				         (150 @ 25).
				         (260 @ 100).
				         (150 @ 175).
				         (150 @ 120).
				         (0 @ 120) }
		         color: Color lightGray
		         borderWidth: 5
		         borderColor: Color black.
	morph scale: 0.25.
	^ morph
]

{ #category : #'event handling' }
ActivePolygonMorph >> handlesMouseOver: anEvent [
	^ true
]

{ #category : #accessing }
ActivePolygonMorph >> infoMorph [

	| mainMorph stringMorph |
	mainMorph := BorderedMorph new.
	stringMorph := StringMorph contents: infoText.
	mainMorph
		color: self theme class baseColor;
		borderColor: self color;
		borderWidth: 2;
		width: stringMorph width + 10;
		addMorphCentered: stringMorph.
	^ mainMorph
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
