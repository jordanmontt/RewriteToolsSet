Class {
	#name : #RenrakuInitialization,
	#superclass : #CustomRewriteRule,
	#category : #'RewriteCustomRules-RefactoringRenraku'
}

{ #category : #initialization }
RenrakuInitialization >> initialize [
	
	| searchForPattern replaceWithPattern |
	super initialize.
	searchForPattern := '| ``@temporaries1 |
`.@Statement1.
`searchFor := ``@string1.
`replaceWith := ``@string2.
rewriteRule replace: `searchFor with: `replaceWith'.
	replaceWithPattern := '| searchForPattern replaceWithPattern |
`.@Statement1.
`searchFor := ``@string1.
`replaceWith := ``@string2.
self replace: `searchFor with: `replaceWith'.
	inputCode := '| searchForPattern replaceWithPattern |
super initialize.
searchForPattern := ''`var := `var''.
replaceWithPattern := ''''.
rewriteRule replace: searchForPattern with: replaceWithPattern'.
	outputCode := '| searchForPattern replaceWithPattern |
super initialize.
searchForPattern := ''`var := `var''.
replaceWithPattern := ''''.
self replace: searchForPattern with: replaceWithPattern'.
	self replace: searchForPattern with: replaceWithPattern
]
