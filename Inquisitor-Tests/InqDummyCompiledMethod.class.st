"
Used in tests to fake a CompiledMethod without having to actually compile it
"
Class {
	#name : #InqDummyCompiledMethod,
	#superclass : #Object,
	#instVars : [
		'sourceCode'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #accessing }
InqDummyCompiledMethod >> sourceCode [
	sourceCode ifNil: [ self error: 'sourceCode variable should not be nil. Maybe this object was not initilised?' ].
	^ sourceCode
]

{ #category : #accessing }
InqDummyCompiledMethod >> sourceCode: aString [
	sourceCode := aString
]
