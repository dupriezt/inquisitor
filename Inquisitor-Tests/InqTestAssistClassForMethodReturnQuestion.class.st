Class {
	#name : #InqTestAssistClassForMethodReturnQuestion,
	#superclass : #InqInquisitorTestAssistClass,
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
InqTestAssistClassForMethodReturnQuestion >> evaluateBlock: aBlock [
	aBlock value
]

{ #category : #'as yet unclassified' }
InqTestAssistClassForMethodReturnQuestion >> nonSpecialReturn [
	Point x: 2 y: 5.
	^ 42
]

{ #category : #'as yet unclassified' }
InqTestAssistClassForMethodReturnQuestion >> returnFalse [
	Point x: 2 y: 5.
	^ false
]

{ #category : #'as yet unclassified' }
InqTestAssistClassForMethodReturnQuestion >> returnImplicitSelf [
	Point x: 2 y: 5.
]

{ #category : #'as yet unclassified' }
InqTestAssistClassForMethodReturnQuestion >> returnInBlock [
	Point x: 2 y: 5.
	self evaluateBlock: [ ^ 42 ].
	^ false
]

{ #category : #'as yet unclassified' }
InqTestAssistClassForMethodReturnQuestion >> returnNil [
	Point x: 2 y: 5.
	^ nil
]

{ #category : #'as yet unclassified' }
InqTestAssistClassForMethodReturnQuestion >> returnSelf [
	Point x: 2 y: 5.
	^ self
]

{ #category : #'as yet unclassified' }
InqTestAssistClassForMethodReturnQuestion >> returnTrue [
	Point x: 2 y: 5.
	^ true
]
