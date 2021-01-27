"
I can create instances of CapturePoint with consecutive timeIndex (starting at 1, then 2, 3, 4...).
"
Class {
	#name : #InqCapturePointFactory,
	#superclass : #Object,
	#instVars : [
		'timeIndex'
	],
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
InqCapturePointFactory >> newCapturePointForContext: aContext andCapturedValue: aValue andBreakpointsEncountered: anOrderedCollection [
	^ InqCapturePoint privateNew receiver: aContext receiver; methodInvocation: (InqMethodInvocation newForContext: aContext); capturedValue: aValue; breakpointsEncountered: anOrderedCollection; timeIndex: self nextTimeIndex; timeStamp: InqTimeStampedStack; newForContext: aContext; yourself
]

{ #category : #'as yet unclassified' }
InqCapturePointFactory >> newCapturePointForReceiver: anObject andMethodInvocation: aMethodInvocation andCapturedValue: aValue andBreakpointsEncountered: anOrderedCollection [
	^ InqCapturePoint privateNew receiver: anObject; methodInvocation: aMethodInvocation; capturedValue: aValue; breakpointsEncountered: anOrderedCollection; timeIndex: self nextTimeIndex; yourself
]

{ #category : #'as yet unclassified' }
InqCapturePointFactory >> nextTimeIndex [
	timeIndex ifNil: [ timeIndex := 0 ].
	timeIndex := timeIndex + 1.
	^ timeIndex
]
