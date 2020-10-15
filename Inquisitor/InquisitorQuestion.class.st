Class {
	#name : #InquisitorQuestion,
	#superclass : #Object,
	#instVars : [
		'node',
		'breakpoints',
		'lastBreakpointHit'
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

{ #category : #updating }
InquisitorQuestion >> breakpoints [
	breakpoints ifNil: [ breakpoints := OrderedCollection new ].
	^ breakpoints
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

{ #category : #'as yet unclassified' }
InquisitorQuestion >> runExecutionWithInquisitor: anInquisitor [
	Breakpoint registerObserver: self.
	[ anInquisitor runExecution ] on: Break do: [ :ex |
		lastBreakpointHit ifNil: [ self error: 'Unexpected case: Break exception signalled, but no breakpoint hit has been registered' ].
		(breakpoints includes: lastBreakpointHit) ifTrue: [ self whenBreakpoint: lastBreakpointHit isHitForBreakException: ex ].
		lastBreakpointHit := nil.
		ex resume
	].
	Breakpoint unregisterObserver: self.
	breakpoints do: [ :brkpt | brkpt remove ].
]

{ #category : #updating }
InquisitorQuestion >> update: aNotification [
	"If this object has been registered as an observer to the Breakpoint class, this method will be called when a breakpoint is hit/added/removed."
	aNotification isBreakpointHitNotification ifFalse: [ ^ self ]. "Notification is not a breakpoint hit"
	"(breakpoints includes: aNotification breakpoint) ifFalse: [ ^ self ]." "Breakpoint hit is not a breakpoint set by this instance"
		
	(aNotification nodes size >= 2) ifTrue: [ self error: 'Unexpected case: breakpoint hit notification contains more than one node'  ].
	lastBreakpointHit := aNotification breakpoint.
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	self subclassResponsibility
]
