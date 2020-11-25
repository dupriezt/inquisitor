Class {
	#name : #InquisitorTestMethodReturnDummy,
	#superclass : #InquisitorTestAssistClass,
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
InquisitorTestMethodReturnDummy >> evaluateBlock: aBlock [
	aBlock value
]

{ #category : #'as yet unclassified' }
InquisitorTestMethodReturnDummy >> nonSpecialReturn [
	Point x: 2 y: 5.
	^ 42
]

{ #category : #'as yet unclassified' }
InquisitorTestMethodReturnDummy >> returnFalse [
	Point x: 2 y: 5.
	^ false
]

{ #category : #'as yet unclassified' }
InquisitorTestMethodReturnDummy >> returnImplicitSelf [
	Point x: 2 y: 5.
]

{ #category : #'as yet unclassified' }
InquisitorTestMethodReturnDummy >> returnInBlock [
	Point x: 2 y: 5.
	self evaluateBlock: [ ^ 42 ].
	^ false
]

{ #category : #'as yet unclassified' }
InquisitorTestMethodReturnDummy >> returnNil [
	Point x: 2 y: 5.
	^ nil
]

{ #category : #'as yet unclassified' }
InquisitorTestMethodReturnDummy >> returnSelf [
	Point x: 2 y: 5.
	^ self
]

{ #category : #'as yet unclassified' }
InquisitorTestMethodReturnDummy >> returnTrue [
	Point x: 2 y: 5.
	^ true
]
