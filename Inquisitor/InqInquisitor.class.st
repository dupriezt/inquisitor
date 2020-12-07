Class {
	#name : #InqInquisitor,
	#superclass : #Object,
	#instVars : [
		'questionHistory',
		'isSilent',
		'lastBreakpointHit',
		'setupCode',
		'executionCode',
		'updateAnnouncer'
	],
	#classVars : [
		'instanceLogAnnouncer',
		'instances',
		'mainInstance'
	],
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
InqInquisitor class >> askQuestion: anInquisitorQuestion [
	self mainInstance ifNil: [ self error: 'Undefined main instance of Inquisitor' ] ifNotNil: [ :mnInst | mnInst askQuestion: anInquisitorQuestion ]
]

{ #category : #'instance creation' }
InqInquisitor class >> clearInstances [
	<script>
	| oldInstances |
	oldInstances := instances copy.
"	instances := nil.
	mainInstance := nil."
	oldInstances do: [ :inq | self removeInstance: inq ].
"	self instanceLogAnnouncer announce: InqInquisitorAllRemoved new"
]

{ #category : #'as yet unclassified' }
InqInquisitor class >> instanceLogAnnouncer [
	instanceLogAnnouncer ifNil: [ instanceLogAnnouncer := Announcer new ].
	^ instanceLogAnnouncer
]

{ #category : #'instance creation' }
InqInquisitor class >> instances [
	instances ifNil: [ instances := OrderedCollection new ].
	^ instances
]

{ #category : #'as yet unclassified' }
InqInquisitor class >> mainInstance [
	^ mainInstance
]

{ #category : #'as yet unclassified' }
InqInquisitor class >> mainInstance: anInstance [
	| oldMainInstance |
	oldMainInstance := anInstance.
	mainInstance := anInstance.
	self instanceLogAnnouncer announce: (InqInquisitorMainInstanceChanged newForOldMainInstance: oldMainInstance andNewMainInstance: anInstance)
]

{ #category : #'instance creation' }
InqInquisitor class >> new [
	| result |
	result := self newWithoutRegisteringInstance.
	self instances add: result.
	self instanceLogAnnouncer announce: (InqInquisitorAdded newFor: result).
	^ result
]

{ #category : #'instance creation' }
InqInquisitor class >> newForCode: aString withSetupCode: aString2 [
	^ self new executionCode: aString; setupCode: aString2; yourself.
]

{ #category : #'instance creation' }
InqInquisitor class >> newWithoutRegisteringInstance [
	^ super new
]

{ #category : #'instance creation' }
InqInquisitor class >> newWithoutRegisteringInstanceForCode: aString withSetupCode: aString2 [
	^ self newWithoutRegisteringInstance executionCode: aString; setupCode: aString2; yourself.
]

{ #category : #'instance creation' }
InqInquisitor class >> removeInstance: anInquisitor [
	self instances remove: anInquisitor.
	self instanceLogAnnouncer announce: (InqInquisitorRemoved newFor: anInquisitor)
]

{ #category : #'question management' }
InqInquisitor >> addAnsweredQuestion: anInquisitorQuestion [
	self questionHistory add: anInquisitorQuestion.
	self displayResultOfQuestion: anInquisitorQuestion
]

{ #category : #accessing }
InqInquisitor >> announceUpdate [
	self updateAnnouncer announce: (InqInquisitorUpdated newFor: self)
]

{ #category : #converting }
InqInquisitor >> asStringForClyCommand [
	^ 'Inquisitor on block: ', self executionCode "codeBlockToExecute sourceNode sourceCode"
]

{ #category : #'question management' }
InqInquisitor >> askQuestion: anInquisitorQuestion [
	anInquisitorQuestion askToInquisitor: self.
	self addAnsweredQuestion: anInquisitorQuestion.
	self announceUpdate
]

{ #category : #'question management' }
InqInquisitor >> displayResultOfQuestion: anInquisitorQuestion [
	self isSilent ifTrue: [ ^ self ].
	self inform: anInquisitorQuestion resultDescription.
	anInquisitorQuestion capturePoints inspect.
]

{ #category : #'question management' }
InqInquisitor >> executionCode [
	executionCode ifNil: [ executionCode := '' ].
	^ executionCode
]

{ #category : #'question management' }
InqInquisitor >> executionCode: aString [
	executionCode := aString.
	self announceUpdate
]

{ #category : #testing }
InqInquisitor >> isEmptyInquisitor [ 
	^ false
]

{ #category : #'question management' }
InqInquisitor >> isSilent [
	isSilent ifNil: [ isSilent := false ].
	^ isSilent
]

{ #category : #'question management' }
InqInquisitor >> isSilent: aBoolean [
	isSilent := aBoolean
]

{ #category : #'as yet unclassified' }
InqInquisitor >> openExecutionOnCapturePoint: aCapturePoint [
	"Runs the execution until it reaches the point at which aCapturePoint was created"
	| breakpoints indexOfNextBreakpointToEncounter sizeOfBreakpointsToEncounter |
	InqInquisitorCapturePointOpener new inquisitor: self; capturePoint: aCapturePoint; open.
	
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
InqInquisitor >> questionHistory [
	questionHistory ifNil: [ questionHistory := OrderedCollection new ].
	^ questionHistory 
]

{ #category : #utility }
InqInquisitor >> runExecution [
	| sourceCode |
	"There is a handler for Break around the setupCode, that ignores the Break and resumes the execution. These Break likely come from the breakpoints inserted by the question, and we do not want the question to see them trigger in the setup code"
	sourceCode := '[', setupCode, '] on: Break do: [:ex | ex resume].
	[', executionCode, '] on: Error do: [ :ex| self inform: ''Inquisitor execution stopped at: '', ex asString ]'.
	OpalCompiler new source: sourceCode; evaluate.
]

{ #category : #'question management' }
InqInquisitor >> setupCode [
	setupCode ifNil: [ setupCode := '' ].
	^ setupCode
]

{ #category : #'question management' }
InqInquisitor >> setupCode: aString [
	setupCode := aString.
	self announceUpdate
]

{ #category : #accessing }
InqInquisitor >> updateAnnouncer [
	updateAnnouncer ifNil: [ updateAnnouncer := Announcer new ].
	^ updateAnnouncer
]
