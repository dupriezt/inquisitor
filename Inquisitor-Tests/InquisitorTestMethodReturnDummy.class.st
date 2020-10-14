Class {
	#name : #InquisitorTestMethodReturnDummy,
	#superclass : #Object,
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
InquisitorTestMethodReturnDummy >> methodWithReturnStatement [
	Point x: 42 y: 42.
	Point new.
	^ 42
]

{ #category : #'as yet unclassified' }
InquisitorTestMethodReturnDummy >> methodWithReturnWithoutReturnAtTheEnd: aBoolean [
	Point x: 42 y: 42.
	Point new.
	aBoolean ifTrue: [ ^ 42 ]
]

{ #category : #'as yet unclassified' }
InquisitorTestMethodReturnDummy >> methodWithoutReturnStatement [
	Point x: 42 y: 42.
	Point new.
]
