Class {
	#name : #InquisitorQuestion,
	#superclass : #Object,
	#instVars : [
		'node'
	],
	#category : #Inquisitor
}

{ #category : #testing }
InquisitorQuestion class >> isAbstract [
	^ self = InquisitorQuestion 
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> askToInquisitor: anInquisitor [
	"Answer the question, using anInquisitor to run the execution. Must call 'anInquisitor addResolvedQuestion: self' when done"
	self subclassResponsibility 
]

{ #category : #accessing }
InquisitorQuestion >> node [
	^ node
]

{ #category : #accessing }
InquisitorQuestion >> node: aRBProgramNode [
	node := aRBProgramNode 
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> resultDescription [
	"Returns a string describing the result of this question"
	^ self subclassResponsibility
]
