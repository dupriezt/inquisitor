"
I can create instances of CapturePoint with consecutive timeIndex (starting at 1, then 2, 3, 4...).
"
Class {
	#name : #CapturePointFactory,
	#superclass : #Object,
	#instVars : [
		'timeIndex'
	],
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
CapturePointFactory >> newCapturePointForContext: aContext andCapturedValue: aValue andBreakpointsEncountered: anOrderedCollection [
	^ CapturePoint privateNew receiver: aContext receiver; methodInvocation: (MethodInvocation newForContext: aContext); capturedValue: aValue; breakpointsEncountered: anOrderedCollection; timeIndex: self nextTimeIndex; yourself
]

{ #category : #'as yet unclassified' }
CapturePointFactory >> nextTimeIndex [
	timeIndex ifNil: [ timeIndex := 0 ].
	timeIndex := timeIndex + 1.
	^ timeIndex
]
