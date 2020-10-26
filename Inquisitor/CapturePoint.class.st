Class {
	#name : #CapturePoint,
	#superclass : #Object,
	#instVars : [
		'timeIndex',
		'codeOwner',
		'methodInvocation',
		'capturedValue',
		'breakpointsEncountered'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
CapturePoint class >> newForContext: aContext andCapturedValue: aValue andBreakpointsEncountered: anOrderedCollection [
	^ self new codeOwner: aContext receiver; methodInvocation: (MethodInvocation newForContext: aContext); capturedValue: aValue; breakpointsEncountered: anOrderedCollection; yourself
]

{ #category : #accessing }
CapturePoint >> breakpointsEncountered [
	breakpointsEncountered ifNil: [ breakpointsEncountered := OrderedCollection new ].
	^ breakpointsEncountered
]

{ #category : #accessing }
CapturePoint >> breakpointsEncountered: anObject [
	breakpointsEncountered := anObject
]

{ #category : #accessing }
CapturePoint >> capturedValue [
	^ capturedValue
]

{ #category : #accessing }
CapturePoint >> capturedValue: anObject [
	capturedValue := anObject
]

{ #category : #accessing }
CapturePoint >> codeOwner [
	^ codeOwner
]

{ #category : #accessing }
CapturePoint >> codeOwner: anObject [
	codeOwner := anObject
]

{ #category : #accessing }
CapturePoint >> methodInvocation [
	^ methodInvocation
]

{ #category : #accessing }
CapturePoint >> methodInvocation: anObject [
	methodInvocation := anObject
]

{ #category : #accessing }
CapturePoint >> timeIndex [
	^ timeIndex
]

{ #category : #accessing }
CapturePoint >> timeIndex: anObject [
	timeIndex := anObject
]
