Class {
	#name : #InquisitorCapturePointOpener,
	#superclass : #Object,
	#instVars : [
		'inquisitor',
		'capturePoint',
		'lastBreakpointHit',
		'breakpointPath'
	],
	#classVars : [
		'mainInstance'
	],
	#category : #Inquisitor
}

{ #category : #accessing }
InquisitorCapturePointOpener >> breakpointPath [
	breakpointPath ifNil: [ self capturePoint breakpointsEncountered ifEmpty: [ self error: 'Unexpected Case: capturePoint''s list of encountered breakpoints is empty' ]. breakpointPath := self capturePoint breakpointsEncountered copy. ].
	^ breakpointPath
]

{ #category : #accessing }
InquisitorCapturePointOpener >> capturePoint [
	^ capturePoint
]

{ #category : #accessing }
InquisitorCapturePointOpener >> capturePoint: anObject [
	capturePoint := anObject
]

{ #category : #'instance creation' }
InquisitorCapturePointOpener >> capturePointReached [
	"If @breakpointPath is empty, it means the execution encountered all the breakpoints of the path to @capturePoint, so it reached it. Otherwise, there are still breakpoints to encounter before the execution reaches @capturePoint"
	^ self breakpointPath isEmpty
]

{ #category : #'as yet unclassified' }
InquisitorCapturePointOpener >> encounteredNextBreakpoint [
	"The execution encountered the next breakpoint in @breakpointPath. So we remove it from the list."
	self breakpointPath removeAt: 1
]

{ #category : #accessing }
InquisitorCapturePointOpener >> inquisitor [
	^ inquisitor
]

{ #category : #accessing }
InquisitorCapturePointOpener >> inquisitor: anObject [
	inquisitor := anObject
]

{ #category : #'instance creation' }
InquisitorCapturePointOpener >> installBreakpoints [
	self relevantBreakpoints do: [ :brkpt | brkpt install ].
]

{ #category : #'as yet unclassified' }
InquisitorCapturePointOpener >> nextBreakpointInPath [
	"Returns the next breakpoint the execution is supposed to encounter on the way to @capturePoint"
	^ self breakpointPath first
]

{ #category : #'instance creation' }
InquisitorCapturePointOpener >> open [
	"Run the execution on which @inquisitor is based, until @capturePoint is reached, and open it in a debugger"
	self installBreakpoints.
	self registerToBreakpointHitAnnouncements.
	"[inquisitor runExecution] on: Break do: [:ex | self removeBreakpoints. ex pass ]."
	[
		[inquisitor runExecution] on: Break do: [ :ex |
			"If the execution already reached @capturePoint and this handler is activated, it means the user used the debugger that opened on @capturePoint to step the execution, and it reached a breakpoint. If the breakpoint reached is one this instance installed, we resume the execution (i.e. ignore this breakpoint). Otherwise, it is a breakpoint that was set by someone else, so we let the Break exception pass through this handler"
			self capturePointReached ifTrue: [ 
				(self relevantBreakpoints includes: lastBreakpointHit) ifTrue: [ ex resume ] ifFalse: [ ex pass ].
			].
			lastBreakpointHit ifNil: [ self error: 'Unexpected Case: Break exception signalled, but no breakpoint hit registered' ].
			"If the last breakpoint hit is not one of those we installed, ignore it and this exception by resuming the execution"
			(self relevantBreakpoints includes: lastBreakpointHit) ifFalse: [ ex resume ].
			(lastBreakpointHit == self nextBreakpointInPath) ifTrue: [ self encounteredNextBreakpoint ] ifFalse: [ self error: 'Unexpected Case: encountered a breakpoint that we installed, but that is not the next breakpoint on the path to @capturePoint' ].
			"If the execution reached @capturePoint, we simply let the debugger open. Otherwise, there are still breakpoints to encounter so we let the execution continue"
			self capturePointReached ifTrue: [ ex pass ] ifFalse: [ ex resume ].
		]	
	] ensure: [	self removeBreakpoints ].
	self unregisterFromBreakpointHitAnnouncements.
]

{ #category : #'as yet unclassified' }
InquisitorCapturePointOpener >> registerBreakpointHit: aBreakpointHit [
	"Called by the announcer of BreakpointHit announcement"
	lastBreakpointHit := aBreakpointHit breakpoint
]

{ #category : #'instance creation' }
InquisitorCapturePointOpener >> registerToBreakpointHitAnnouncements [
	SystemAnnouncer uniqueInstance when: BreakpointHit send: #registerBreakpointHit: to: self
]

{ #category : #'as yet unclassified' }
InquisitorCapturePointOpener >> relevantBreakpoints [
	"Returns a set containing the breakpoints encountered on the way to reach @capturePoint. A breakpoint will only be present once in this set even if it was encountered multiple times"
	^ capturePoint breakpointsEncountered asIdentitySet
]

{ #category : #'instance creation' }
InquisitorCapturePointOpener >> removeBreakpoints [
	self relevantBreakpoints do: [ :brkpt | brkpt remove ].
]

{ #category : #'instance creation' }
InquisitorCapturePointOpener >> unregisterFromBreakpointHitAnnouncements [
	SystemAnnouncer uniqueInstance unsubscribe: self
]
