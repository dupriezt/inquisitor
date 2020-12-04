Class {
	#name : #InqInquisitorQuestion,
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
InqInquisitorQuestion class >> isAbstract [
	^ self = InqInquisitorQuestion 
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> askToInquisitor: anInquisitor [
	"Answer the question, using anInquisitor to run the execution."
	self subclassResponsibility 
]

{ #category : #updating }
InqInquisitorQuestion >> breakpoints [
	breakpoints ifNil: [ breakpoints := OrderedCollection new ].
	^ breakpoints
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> breakpointsEncountered [
	breakpointsEncountered ifNil: [ breakpointsEncountered := OrderedCollection new ].
	^ breakpointsEncountered
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> capturePointFactory [
	capturePointFactory ifNil: [ capturePointFactory := InqCapturePointFactory new ].
	^ capturePointFactory
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> capturePoints [
	capturePoints ifNil: [ capturePoints := OrderedCollection new ].
	^ capturePoints
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> fullMethodNameOfNode [
	^ node methodNode methodClass asString, '>>#', node methodNode selector asString
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> keepFirst: anInteger ofCollection: aCollection [
	"Returns a copy of @aCollection containing its first @anInteger elements. If @aCollection has less elements, return a copy of the whole collection (Unlike SequenceableCollection>>#first: which signals an error in this case)"
	(aCollection size > anInteger) ifTrue: [ ^ aCollection first: anInteger ].
	^ aCollection copy
]

{ #category : #accessing }
InqInquisitorQuestion >> node [
	^ node
]

{ #category : #accessing }
InqInquisitorQuestion >> node: aRBProgramNode [
	node := aRBProgramNode 
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self resultDescription;
		nextPutAll: ')'
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> quickView [
	"Returns a list of associations propertyName->propertyValue about this question. To be used to display its important properties"
	| result |
	result := OrderedCollection new.
	result add: #node->(self node sourceCode);
		add: #method -> (self node methodNode methodClass asString, '>>', self node methodNode selector);
		add: #capturePoints -> (self capturePoints size).
	^ result
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> registerBreakpointHit: aBreakpointHit [
	"Called by the announcer of BreakpointHit announcement"
	lastBreakpointHit := aBreakpointHit breakpoint
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> resultDescription [
	"Returns a string describing the result of this question"
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> runExecutionWithInquisitor: anInquisitor [
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
InqInquisitorQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	self subclassResponsibility
]
