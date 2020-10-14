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
InquisitorQuestion >> result [
	"Must return the result of the question: the data object (whatever it is) describing the answer to this question"
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> resultDescription [
	"Returns a string describing the result of this question"
	^ self subclassResponsibility
]

{ #category : #updating }
InquisitorQuestion >> update: aNotification [
	"If this object has been registered as an observer to the Breakpoint class, this method will be called when a breakpoint is hit/added/removed."
	aNotification isBreakpointHitNotification ifTrue: [
		self whenBreakpointIsHit: aNotification breakpoint
	]
]

{ #category : #updating }
InquisitorQuestion >> whenBreakpointIsHit: aBreakpoint [
	self subclassResponsibility 
]
