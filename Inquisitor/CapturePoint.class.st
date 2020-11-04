"
# Instance Variables

- **timeIndex**: Int. Each CapturePoint registered during an execution has a unique timeIndex. This represents the order in which the CapturePoints were registered. Starts at 0. The creator of a CapturePoint sets its timeIndex.
- **receiver**: Object. Receiver of the method invocation in which the CapturePoint is registered
- **methodInvocation**: MethodInvocation. Object representing the method invocation in which the CapturePoint is registered. For example, if the same method on the same object is called multiple times and a CapturePoint is registered each time, these CapturePoints will have the same ""receiver"" variable, but different ""methodInvocation"" variables.
- **capturedValue**: Object. Value captured by the CapturePoint. Its precide meaning depends on the Inquisitor question that was asked.
- **breakpointsEncountered**: List<Breakpoints>. List of the breakpoints *set by the Inquisitor question being asked* that were encountered on the way to the registration of this CapturePoint (including the breakpoint where this CapturePoint was registered)
"
Class {
	#name : #CapturePoint,
	#superclass : #Object,
	#instVars : [
		'timeIndex',
		'methodInvocation',
		'capturedValue',
		'breakpointsEncountered',
		'receiver'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
CapturePoint class >> newForContext: aContext andCapturedValue: aValue andBreakpointsEncountered: anOrderedCollection [
	^ self new receiver: aContext receiver; methodInvocation: (MethodInvocation newForContext: aContext); capturedValue: aValue; breakpointsEncountered: anOrderedCollection; yourself
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
CapturePoint >> methodInvocation [
	^ methodInvocation
]

{ #category : #accessing }
CapturePoint >> methodInvocation: anObject [
	methodInvocation := anObject
]

{ #category : #accessing }
CapturePoint >> receiver [
	^ receiver
]

{ #category : #accessing }
CapturePoint >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
CapturePoint >> timeIndex [
	^ timeIndex
]

{ #category : #accessing }
CapturePoint >> timeIndex: anObject [
	timeIndex := anObject
]
