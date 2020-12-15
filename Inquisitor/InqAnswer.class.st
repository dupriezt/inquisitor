Class {
	#name : #InqAnswer,
	#superclass : #Object,
	#instVars : [
		'inquisitor',
		'question',
		'capturePoints'
	],
	#category : #Inquisitor
}

{ #category : #accessing }
InqAnswer >> capturePoints [

	^ capturePoints
]

{ #category : #accessing }
InqAnswer >> capturePoints: anObject [

	capturePoints := anObject
]

{ #category : #accessing }
InqAnswer >> inquisitor [

	^ inquisitor
]

{ #category : #accessing }
InqAnswer >> inquisitor: anObject [

	inquisitor := anObject
]

{ #category : #printing }
InqAnswer >> printOn: aStream [
	aStream nextPutAll: 'Answer to '.
	self question printOn: aStream
]

{ #category : #accessing }
InqAnswer >> question [

	^ question
]

{ #category : #accessing }
InqAnswer >> question: anObject [

	question := anObject
]
