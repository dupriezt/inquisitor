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
		'mainInstance',
		'openUIs'
	],
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
InqInquisitor class >> askQuestion: anInquisitorQuestion [
	self mainInstance ifNil: [ self error: 'Undefined main instance of Inquisitor' ] ifNotNil: [ :mnInst | mnInst askQuestion: anInquisitorQuestion ]
]

{ #category : #'as yet unclassified' }
InqInquisitor class >> clearAllSubscriptions [
	<script>
	self instanceLogAnnouncer subscriptions reset.
	self allInstancesDo: [ :inq | inq updateAnnouncer subscriptions reset ]
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

{ #category : #'as yet unclassified' }
InqInquisitor class >> numberOfOpenUIs [
	numberOfOpenUIs ifNil: [ numberOfOpenUIs := 0 ].
	^ numberOfOpenUIs
]

{ #category : #'as yet unclassified' }
InqInquisitor class >> openUIs [
	openUIs ifNil: [ openUIs := IdentitySet new ].
	^ openUIs
]

{ #category : #'instance creation' }
InqInquisitor class >> removeInstance: anInquisitor [
	self instances remove: anInquisitor.
	self instanceLogAnnouncer announce: (InqInquisitorRemoved newFor: anInquisitor)
]

{ #category : #'as yet unclassified' }
InqInquisitor class >> resetOpenUIs [
	<script>
	openUIs := nil
]

{ #category : #'as yet unclassified' }
InqInquisitor class >> uiCloses: ui [
	"Call this when a workbench ui closes"
	[self openUIs remove: ui] on: NotFound do: [].
]

{ #category : #'as yet unclassified' }
InqInquisitor class >> uiIsOpen [
	"Whether at least one workbench ui is currently open"
	"^ numberOfOpenUIs > 0"
	^ self openUIs size > 0
]

{ #category : #'as yet unclassified' }
InqInquisitor class >> uiOpens: ui [
	"Call this when a workbench ui opens"
	self openUIs add: ui.
]

{ #category : #'question management' }
InqInquisitor >> addAnsweredQuestion: anInquisitorQuestion [
	self questionHistory add: anInquisitorQuestion.
	self displayResultOfQuestion: anInquisitorQuestion
]

{ #category : #accessing }
InqInquisitor >> announceCodeUpdate [
	self announceUpdate: (InqInquisitorUpdatedCode newFor: self)
	
]

{ #category : #accessing }
InqInquisitor >> announceQuestionHistoryUpdate [
	self announceUpdate: (InqInquisitorUpdatedQuestionHistory newFor: self)
	
]

{ #category : #accessing }
InqInquisitor >> announceSetupUpdate [
	self announceUpdate: (InqInquisitorUpdatedSetup newFor: self)
	
]

{ #category : #accessing }
InqInquisitor >> announceUpdate: anUpdateAnnouncement [
	self updateAnnouncer announce: anUpdateAnnouncement.
	
]

{ #category : #converting }
InqInquisitor >> asStringForClyCommand [
	^ 'Inquisitor on block: ', self executionCode "codeBlockToExecute sourceNode sourceCode"
]

{ #category : #'question management' }
InqInquisitor >> askQuestion: anInquisitorQuestion [
	anInquisitorQuestion askToInquisitor: self.
	self addAnsweredQuestion: anInquisitorQuestion.
	self announceQuestionHistoryUpdate.
]

{ #category : #'question management' }
InqInquisitor >> displayResultOfQuestion: anInquisitorQuestion [
	self isSilent ifTrue: [ ^ self ].
	self inform: anInquisitorQuestion resultDescription.
	anInquisitorQuestion executionTermination isNormalTermination ifFalse: [ self inform: 'Warning: the execution signalled an error' ].
	self class uiIsOpen ifFalse: [
		InqAnswer new inquisitor: self; question: anInquisitorQuestion; capturePoints: anInquisitorQuestion capturePoints; inspect]
]

{ #category : #'question management' }
InqInquisitor >> executionCode [
	executionCode ifNil: [ executionCode := '' ].
	^ executionCode
]

{ #category : #'question management' }
InqInquisitor >> executionCode: aString [
	executionCode := aString.
	self announceCodeUpdate
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
	InqInquisitorCapturePointOpener new inquisitor: self; capturePoint: aCapturePoint; open.
]

{ #category : #accessing }
InqInquisitor >> questionHistory [
	questionHistory ifNil: [ questionHistory := OrderedCollection new ].
	^ questionHistory 
]

{ #category : #accessing }
InqInquisitor >> removeQuestion: anInqInquisitorQuestion [
	"Remove @anInqInquisitorQuestion from the @questionHistory list"
	questionHistory remove: anInqInquisitorQuestion.
	self announceQuestionHistoryUpdate
]

{ #category : #utility }
InqInquisitor >> runExecution [
	| sourceCode |
	"There is a handler for Break around the setupCode, that ignores the Break and resumes the execution. These Break likely come from the breakpoints inserted by the question, and we do not want the question to see them trigger in the setup code"
	sourceCode := '[', setupCode, '] on: Break do: [:ex | ex resume].
	', executionCode.
	OpalCompiler new source: sourceCode; evaluate.
]

{ #category : #initialization }
InqInquisitor >> setAsMainInstance [
	InqInquisitor mainInstance: self
]

{ #category : #'question management' }
InqInquisitor >> setupCode [
	setupCode ifNil: [ setupCode := '' ].
	^ setupCode
]

{ #category : #'question management' }
InqInquisitor >> setupCode: aString [
	setupCode := aString.
	self announceSetupUpdate
]

{ #category : #accessing }
InqInquisitor >> updateAnnouncer [
	updateAnnouncer ifNil: [ updateAnnouncer := Announcer new ].
	^ updateAnnouncer
]
