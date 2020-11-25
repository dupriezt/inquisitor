Class {
	#name : #InquisitorQuestion,
	#superclass : #Object,
	#instVars : [
		'node',
		'breakpoints',
		'lastBreakpointHit',
		'capturePoints',
		'breakpointsEncountered',
		'capturePointFactory'
	],
	#category : #Inquisitor
}

{ #category : #testing }
InquisitorQuestion class >> isAbstract [
	^ self = InquisitorQuestion 
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> askToInquisitor: anInquisitor [
	"Answer the question, using anInquisitor to run the execution."
	self subclassResponsibility 
]

{ #category : #updating }
InquisitorQuestion >> breakpoints [
	breakpoints ifNil: [ breakpoints := OrderedCollection new ].
	^ breakpoints
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> breakpointsEncountered [
	breakpointsEncountered ifNil: [ breakpointsEncountered := OrderedCollection new ].
	^ breakpointsEncountered
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> capturePointFactory [
	capturePointFactory ifNil: [ capturePointFactory := CapturePointFactory new ].
	^ capturePointFactory
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> capturePoints [
	capturePoints ifNil: [ capturePoints := OrderedCollection new ].
	^ capturePoints
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> fullMethodNameOfNode [
	^ node methodNode methodClass asString, '>>#', node methodNode selector asString
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> keepFirst: anInteger ofCollection: aCollection [
	"Returns a copy of @aCollection containing its first @anInteger elements. If @aCollection has less elements, return a copy of the whole collection (Unlike SequenceableCollection>>#first: which signals an error in this case)"
	(aCollection size > anInteger) ifTrue: [ ^ aCollection first: anInteger ].
	^ aCollection copy
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
InquisitorQuestion >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self resultDescription;
		nextPutAll: ')'
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> registerBreakpointHit: aBreakpointHit [
	"Called by the announcer of BreakpointHit announcement"
	lastBreakpointHit := aBreakpointHit breakpoint
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
	SystemAnnouncer uniqueInstance when: BreakpointHit send: #registerBreakpointHit: to: self.
	[ anInquisitor runExecution ] on: Break do: [ :ex |
		lastBreakpointHit ifNil: [ self error: 'Unexpected case: Break exception signalled, but no breakpoint hit has been registered' ].
		"We only do something if the breakpoint that was hit belongs to those that this question installed"
		(breakpoints includes: lastBreakpointHit) ifTrue: [ self whenBreakpoint: lastBreakpointHit isHitForBreakException: ex ].
		lastBreakpointHit := nil.
		ex resume
	].
	SystemAnnouncer uniqueInstance unsubscribe: self.
	breakpoints do: [ :brkpt | brkpt remove ].
]

{ #category : #'as yet unclassified' }
InquisitorQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	self subclassResponsibility
]
