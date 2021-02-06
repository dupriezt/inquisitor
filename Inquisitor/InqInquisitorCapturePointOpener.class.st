Class {
	#name : #InqInquisitorCapturePointOpener,
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
InqInquisitorCapturePointOpener >> breakpointPath [
	breakpointPath ifNil: [ self capturePoint breakpointsEncountered ifEmpty: [ self error: 'Unexpected Case: capturePoint''s list of encountered breakpoints is empty' ]. breakpointPath := self capturePoint breakpointsEncountered copy. ].
	^ breakpointPath
]

{ #category : #accessing }
InqInquisitorCapturePointOpener >> capturePoint [
	^ capturePoint
]

{ #category : #accessing }
InqInquisitorCapturePointOpener >> capturePoint: anObject [
	capturePoint := anObject
]

{ #category : #'instance creation' }
InqInquisitorCapturePointOpener >> capturePointReached [
	"If @breakpointPath is empty, it means the execution encountered all the breakpoints of the path to @capturePoint, so it reached it. Otherwise, there are still breakpoints to encounter before the execution reaches @capturePoint"
	^ self breakpointPath isEmpty
]

{ #category : #'instance creation' }
InqInquisitorCapturePointOpener >> disableBreakpoints [
	self relevantBreakpoints do: [ :brkpt | brkpt disable ].
]

{ #category : #'instance creation' }
InqInquisitorCapturePointOpener >> enableBreakpoints [
	self relevantBreakpoints do: [ :brkpt | brkpt enable ].
]

{ #category : #'as yet unclassified' }
InqInquisitorCapturePointOpener >> encounteredNextBreakpoint [
	"The execution encountered the next breakpoint in @breakpointPath. So we remove it from the list."
	self breakpointPath removeAt: 1
]

{ #category : #accessing }
InqInquisitorCapturePointOpener >> inquisitor [
	^ inquisitor
]

{ #category : #accessing }
InqInquisitorCapturePointOpener >> inquisitor: anObject [
	inquisitor := anObject
]

{ #category : #'as yet unclassified' }
InqInquisitorCapturePointOpener >> nextBreakpointInPath [
	"Returns the next breakpoint the execution is supposed to encounter on the way to @capturePoint"
	^ self breakpointPath first
]

{ #category : #'instance creation' }
InqInquisitorCapturePointOpener >> open [
	"Run the execution on which @inquisitor is based, until @capturePoint is reached, and open it in a debugger"
	self capturePoint isOpenable ifFalse: [ self error: 'You are trying to open a CapturePoint that has been marked as "not openable". You can proceed, but it may freeze your image' ].
	self enableBreakpoints.
	self registerToBreakpointHitAnnouncements.
	"[inquisitor runExecution] on: Break do: [:ex | self removeBreakpoints. ex pass ]."
	[[
		[inquisitor runExecution] on: Break do: [ :ex |
			"If the execution already reached @capturePoint and this handler is activated, it means the user used the debugger that opened on @capturePoint to step the execution, and it reached a breakpoint. If the breakpoint reached is one this instance installed, we resume the execution (i.e. ignore this breakpoint). Otherwise, it is a breakpoint that was set by someone else, so we let the Break exception pass through this handler"
			self capturePointReached ifTrue: [ 
				(self relevantBreakpoints includes: lastBreakpointHit) ifTrue: [ex resume]
					ifFalse: [ ex pass ].
			].
			lastBreakpointHit ifNil: [ self error: 'Unexpected Case: Break exception signalled, but no breakpoint hit registered' ].
			"If the last breakpoint hit is not one of those we installed, ignore it and this exception by resuming the execution"
			(self relevantBreakpoints includes: lastBreakpointHit) ifFalse: [ ex resume ].
			(lastBreakpointHit == self nextBreakpointInPath) ifTrue: [ self encounteredNextBreakpoint ]
				ifFalse: [ self error: 'Unexpected Case: encountered a breakpoint that we installed, but that is not the next breakpoint on the path to @capturePoint' ].
			"If the execution reached @capturePoint, we simply let the debugger open. Otherwise, there are still breakpoints to encounter so we let the execution continue"
			self capturePointReached ifTrue: [ ex pass ] ifFalse: [ ex resume ].
		]
	] on: Halt do: [:ex | ex isBreak ifTrue: [ ex pass "It's really a Break and not a Halt, we let it pass so that it opens a debugger at the right place in the execution" ] ifFalse: [ ex resume "It's a Halt and not a Break. We resume it because we want to ignore 'self halt' statements left in the code by the user"]]] ensure: [	self unregisterFromBreakpointHitAnnouncements. self disableBreakpoints ]
	.
]

{ #category : #'as yet unclassified' }
InqInquisitorCapturePointOpener >> registerBreakpointHit: aBreakpointHit [
	"Called by the announcer of BreakpointHit announcement"
	lastBreakpointHit := aBreakpointHit breakpoint
]

{ #category : #'instance creation' }
InqInquisitorCapturePointOpener >> registerToBreakpointHitAnnouncements [
	SystemAnnouncer uniqueInstance when: BreakpointHit send: #registerBreakpointHit: to: self
]

{ #category : #'as yet unclassified' }
InqInquisitorCapturePointOpener >> relevantBreakpoints [
	"Returns a set containing the breakpoints encountered on the way to reach @capturePoint. A breakpoint will only be present once in this set even if it was encountered multiple times"
	^ capturePoint breakpointsEncountered asIdentitySet
]

{ #category : #'instance creation' }
InqInquisitorCapturePointOpener >> unregisterFromBreakpointHitAnnouncements [
	SystemAnnouncer uniqueInstance unsubscribe: self
]
