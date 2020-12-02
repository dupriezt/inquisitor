Class {
	#name : #InqEmptyQuestion,
	#superclass : #InqInquisitorQuestion,
	#category : #'Inquisitor-UI'
}

{ #category : #'as yet unclassified' }
InqEmptyQuestion >> askToInquisitor: anInquisitor [
	"Answer the question, using anInquisitor to run the execution."
	self error: 'This question is not meant to be asked'
]

{ #category : #'as yet unclassified' }
InqEmptyQuestion >> printOn: aStream [
	aStream nextPutAll: 'Question history is empty'
]

{ #category : #'as yet unclassified' }
InqEmptyQuestion >> resultDescription [
	"Returns a string describing the result of this question"
	^ 'Empty question'
]

{ #category : #'as yet unclassified' }
InqEmptyQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	self error: 'This question is not meant to be asked'
]
