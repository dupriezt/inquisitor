Class {
	#name : #InqInquisitorTestMethodReturnDummy,
	#superclass : #InqInquisitorTestAssistClass,
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
InqInquisitorTestMethodReturnDummy >> evaluateBlock: aBlock [
	aBlock value
]

{ #category : #'as yet unclassified' }
InqInquisitorTestMethodReturnDummy >> nonSpecialReturn [
	Point x: 2 y: 5.
	^ 42
]

{ #category : #'as yet unclassified' }
InqInquisitorTestMethodReturnDummy >> returnFalse [
	Point x: 2 y: 5.
	^ false
]

{ #category : #'as yet unclassified' }
InqInquisitorTestMethodReturnDummy >> returnImplicitSelf [
	Point x: 2 y: 5.
]

{ #category : #'as yet unclassified' }
InqInquisitorTestMethodReturnDummy >> returnInBlock [
	Point x: 2 y: 5.
	self evaluateBlock: [ ^ 42 ].
	^ false
]

{ #category : #'as yet unclassified' }
InqInquisitorTestMethodReturnDummy >> returnNil [
	Point x: 2 y: 5.
	^ nil
]

{ #category : #'as yet unclassified' }
InqInquisitorTestMethodReturnDummy >> returnSelf [
	Point x: 2 y: 5.
	^ self
]

{ #category : #'as yet unclassified' }
InqInquisitorTestMethodReturnDummy >> returnTrue [
	Point x: 2 y: 5.
	^ true
]
