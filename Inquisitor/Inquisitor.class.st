Class {
	#name : #Inquisitor,
	#superclass : #Object,
	#instVars : [
		'testMethodName',
		'testClass',
		'questionHistory',
		'isSilent',
		'lastBreakpointHit',
		'codeBlockToExecute'
	],
	#classVars : [
		'mainInstance'
	],
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
Inquisitor class >> askQuestion: anInquisitorQuestion [
	self mainInstance ifNil: [ self error: 'Undefined main instance of Inquisitor' ] ifNotNil: [ :mnInst | mnInst askQuestion: anInquisitorQuestion ]
]

{ #category : #'as yet unclassified' }
Inquisitor class >> mainInstance [
	^ mainInstance
]

{ #category : #'as yet unclassified' }
Inquisitor class >> mainInstance: anInstance [
	mainInstance := anInstance
]

{ #category : #'instance creation' }
Inquisitor class >> newOnCodeBlock: aBlockClosure [
	| i |
	i := self new codeBlockToExecute: aBlockClosure; yourself.
	Inquisitor mainInstance: i.
	i inspect
]

{ #category : #'question management' }
Inquisitor >> addResolvedQuestion: anInquisitorQuestion [
	| entry |
	entry := Dictionary new.
	entry at: #q put: anInquisitorQuestion.
	entry at: #a put: anInquisitorQuestion result.
	self questionHistory add: entry.
	self displayResultOfQuestion: anInquisitorQuestion
]

{ #category : #'question management' }
Inquisitor >> askQuestion: anInquisitorQuestion [
	anInquisitorQuestion askToInquisitor: self
]

{ #category : #accessing }
Inquisitor >> codeBlockToExecute [
	^ codeBlockToExecute
]

{ #category : #accessing }
Inquisitor >> codeBlockToExecute: aBlockClosure [
	codeBlockToExecute := aBlockClosure
]

{ #category : #'question management' }
Inquisitor >> displayResultOfQuestion: anInquisitorQuestion [
	self isSilent ifTrue: [ ^ self ].
	self inform: anInquisitorQuestion resultDescription.
	anInquisitorQuestion result inspect.
]

{ #category : #'question management' }
Inquisitor >> isSilent [
	isSilent ifNil: [ isSilent := false ].
	^ isSilent
]

{ #category : #'question management' }
Inquisitor >> isSilent: aBoolean [
	isSilent := aBoolean
]

{ #category : #'as yet unclassified' }
Inquisitor >> openExecutionOnCapturePoint: aCapturePoint [
	"Runs the execution until it reaches the point at which aCapturePoint was created"
	| breakpoints indexOfNextBreakpointToEncounter sizeOfBreakpointsToEncounter |
	InquisitorCapturePointOpener new inquisitor: self; capturePoint: aCapturePoint; open.
	
	"aCapturePoint breakpointsEncountered ifEmpty: [ self error: 'Unexpected case: CapturePoint has empty list of breakpoints encountered' ].
	""List of the breakpoints encountered 1+ times on the way to the capture point""
	breakpoints := aCapturePoint breakpointsEncountered asIdentitySet asOrderedCollection.
	""Installing the breakpoints required by the capture point""
	breakpoints do: [ :brkpt | brkpt install ].
	indexOfNextBreakpointToEncounter := 1.
	sizeOfBreakpointsToEncounter := aCapturePoint breakpointsEncountered size.
	Breakpoint registerObserver: self.
	self halt.
	[self runExecution ] on: Break do: [ :ex |
		self flag: 'debug code'.
		self inform: 'On Break'.
		lastBreakpointHit ifNil: [ self error: 'Unexpected case: Break exception signalled, but no breakpoint hit has been registered' ].
		(breakpoints includes: lastBreakpointHit) ifFalse: [ lastBreakpointHit := nil. ex resume ""Unrelated breakpoint has been hit. Resuming the execution"" ].
		(lastBreakpointHit = (aCapturePoint breakpointsEncountered at: indexOfNextBreakpointToEncounter)) ifTrue: [ indexOfNextBreakpointToEncounter := indexOfNextBreakpointToEncounter + 1 ] ifFalse: [ self error: 'Unexpected case: breakpoint encountered at the wrong time' ].
		(indexOfNextBreakpointToEncounter > sizeOfBreakpointsToEncounter) ifTrue: [ ""Execution reached the capture point. Remove the breakpoints and let the Break exception get opened in a debugger"" breakpoints do: [:brkpt | brkpt remove]. ex pass ] ifFalse: [ ""Execution has not yet reached the capture point"" lastBreakpointHit := nil. ex resume ].
	]
""TODO test if it works: after capture point has been reached, execution reaches a breakpoint. Does it trigger this Break handler and mess things up?"""
]

{ #category : #accessing }
Inquisitor >> questionHistory [
	questionHistory ifNil: [ questionHistory := OrderedCollection new ].
	^ questionHistory 
]

{ #category : #utility }
Inquisitor >> runExecution [
	| testInstance executionBlock |
	self codeBlockToExecute ifNil: [ 
		"This Inquisitor is not a specific code block, but rather on a test method"	
		testInstance := testClass new.
		testInstance setUp.
		executionBlock := [testInstance perform: testMethodName]
	] ifNotNil: [ :cdblk | "This inquisitor is on a specific code block"
		executionBlock := cdblk
	].
	executionBlock on: TestFailure do: [ :ex| self inform: 'Inquisitor execution stopped at: ', ex asString ]
]

{ #category : #accessing }
Inquisitor >> testClass [
	^ testClass
]

{ #category : #accessing }
Inquisitor >> testClass: anObject [
	testClass := anObject
]

{ #category : #tests }
Inquisitor >> testMethodFullName [
	^ self testClass asString, '>>#', self testMethodName asString
]

{ #category : #accessing }
Inquisitor >> testMethodName [
	^ testMethodName
]

{ #category : #accessing }
Inquisitor >> testMethodName: anObject [
	testMethodName := anObject
]

{ #category : #'as yet unclassified' }
Inquisitor >> update: aNotification [
	"If this object has been registered as an observer to the Breakpoint class, this method will be called when a breakpoint is hit/added/removed."
	self flag: 'debug code'.
	self inform: 'notification:', aNotification asString.
	aNotification isBreakpointHitNotification ifFalse: [ ^ self ]. "Notification is not a breakpoint hit"
	(aNotification nodes size >= 2) ifTrue: [ self error: 'Unexpected case: breakpoint hit notification contains more than one node'  ].
	lastBreakpointHit := aNotification breakpoint.
]
