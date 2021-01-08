Class {
	#name : #InqQuestionException,
	#superclass : #Exception,
	#category : #Inquisitor
}

{ #category : #testing }
InqQuestionException class >> isAbstract [ 
	^ self == InqQuestionException
]

{ #category : #testing }
InqQuestionException >> isInquisitorQuestionException [ 
	^ true
]
