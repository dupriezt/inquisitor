Class {
	#name : #InqInquisitorQuestion,
	#superclass : #Object,
	#instVars : [
		'node',
		'breakpoints',
		'lastBreakpointHit',
		'capturePoints',
		'breakpointsEncountered',
		'capturePointFactory',
		'executionTermination'
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

{ #category : #accessing }
InqInquisitorQuestion >> executionTermination [
	^ executionTermination
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

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> name [
	^ self class name
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
	aStream nextPutAll: self name.
	"super printOn: aStream."
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
		add: #capturePoints -> (self capturePoints size);
		add: #termination -> (self executionTermination description).
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
	[ anInquisitor runExecution ] on: Exception do: [ :ex |
		GV v0 add: ex.
		"- Exception is a notification that will pass without effect if not handled, so we do not care"
		ex isNotification ifTrue: [ ex pass ].
		"- Exception is from a breakpoint"
		ex isBreak ifTrue: [
			lastBreakpointHit ifNil: [ self error: 'Unexpected case: Break exception signalled, but no breakpoint hit has been registered' ].
			"We only do something if the breakpoint that was hit belongs to those that this question installed"
			(breakpoints includes: lastBreakpointHit) ifTrue: [ self whenBreakpoint: lastBreakpointHit isHitForBreakException: ex ].
			lastBreakpointHit := nil.
			ex resume
		].
		"- Exception is from a halt statement. Ignore it and resume the execution"
		ex isHalt ifTrue: [ ex resume ].
		"- Exception is neither from a breakpoint or a halt. This means the execution signaled a non-debug exception that it did not handle. Stop the execution here."
		executionTermination := InqExceptionTermination newForDescription: ex description.
	].
	executionTermination ifNil: [
		"i.e. the execution did not finish because of an unhandled non-debug exception, otherwise @executionTermination would have been filled already"
		executionTermination := InqNormalTermination newForDescription: 'Inquisited execution finished normally'
	].
	SystemAnnouncer uniqueInstance unsubscribe: self.
	breakpoints do: [ :brkpt | brkpt remove ].
]

{ #category : #'as yet unclassified' }
InqInquisitorQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	self subclassResponsibility
]
