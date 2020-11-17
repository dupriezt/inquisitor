Class {
	#name : #HitCheckQuestion,
	#superclass : #InquisitorQuestion,
	#instVars : [
		'hitCount',
		'capturePoints',
		'breakpointsEncountered',
		'timeIndex'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
HitCheckQuestion class >> newForNode: aRBProgramNode [
	^ self new node: aRBProgramNode; yourself
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> askToInquisitor: anInquisitor [
	| b |
	hitCount := 0.
	b := Breakpoint new node: node; always; install.
	self breakpoints add: b.
	self runExecutionWithInquisitor: anInquisitor.
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> breakpointsEncountered [
	breakpointsEncountered ifNil: [ breakpointsEncountered := OrderedCollection new ].
	^ breakpointsEncountered
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> capturePoints [
	capturePoints ifNil: [ capturePoints := OrderedCollection new ].
	^ capturePoints
]

{ #category : #accessing }
HitCheckQuestion >> hitCount [
	^ hitCount
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> nextTimeIndex [
	timeIndex ifNil: [ timeIndex := 0 ] ifNotNil: [timeIndex := timeIndex + 1].
	^ timeIndex
]

{ #category : #converting }
HitCheckQuestion >> printOn: aStream [
	aStream
		nextPutAll: hitCount asString;
		nextPutAll: ' hits on node ';
		nextPutAll: node asString
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> result [
	^ capturePoints
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> resultDescription [
	^ 'The execution encountered this node ', capturePoints size asString, ' times'
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	| cp | 
	self breakpointsEncountered add: aBreakpoint.
	cp := CapturePoint newForContext: (aBreakException signalerContext sender) andCapturedValue: nil andBreakpointsEncountered: self breakpointsEncountered.
	cp timeIndex: self nextTimeIndex.
	self capturePoints add: cp.
	hitCount := hitCount + 1
]
