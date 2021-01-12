"
# Instance Variables

- **timeIndex**: Int. Each CapturePoint registered during an execution has a unique timeIndex. This represents the order in which the CapturePoints were registered. Starts at 0. The creator of a CapturePoint sets its timeIndex.
- **receiver**: Object. Receiver of the method invocation in which the CapturePoint is registered
- **methodInvocation**: MethodInvocation. Object representing the method invocation in which the CapturePoint is registered. For example, if the same method on the same object is called multiple times and a CapturePoint is registered each time, these CapturePoints will have the same ""receiver"" variable, but different ""methodInvocation"" variables.
- **capturedValue**: Object. Value captured by the CapturePoint. Its precide meaning depends on the Inquisitor question that was asked.
- **breakpointsEncountered**: List<Breakpoints>. List of the breakpoints *set by the Inquisitor question being asked* that were encountered on the way to the registration of this CapturePoint (including the breakpoint where this CapturePoint was registered)
"
Class {
	#name : #InqCapturePoint,
	#superclass : #Object,
	#instVars : [
		'timeIndex',
		'methodInvocation',
		'capturedValue',
		'breakpointsEncountered',
		'receiver',
		'isOpenable'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqCapturePoint class >> new [
	self error: 'You should instanciate a CapturePointFactory and use it to instanciate CapturePoint'
]

{ #category : #'instance creation' }
InqCapturePoint class >> privateNew [
	"Private method, to be used by CapturePointFactory to instanciate this class"
	^ super new
]

{ #category : #accessing }
InqCapturePoint >> breakpointsEncountered [
	breakpointsEncountered ifNil: [ breakpointsEncountered := OrderedCollection new ].
	^ breakpointsEncountered
]

{ #category : #accessing }
InqCapturePoint >> breakpointsEncountered: anObject [
	breakpointsEncountered := anObject
]

{ #category : #accessing }
InqCapturePoint >> capturedValue [
	^ capturedValue
]

{ #category : #accessing }
InqCapturePoint >> capturedValue: anObject [
	capturedValue := anObject
]

{ #category : #accessing }
InqCapturePoint >> isOpenable [
	"See comment of #isOpenable:"
	isOpenable ifNil: [ isOpenable := true ].
	^ isOpenable
]

{ #category : #accessing }
InqCapturePoint >> isOpenable: aBoolean [
	"Special boolean to prevent CapturePoints created by the ClassInstanciation question from being opened and maybe freezing the image. Maybe this will be fixed in the future and this special boolean will not be needed anymore"
	isOpenable := aBoolean
]

{ #category : #accessing }
InqCapturePoint >> methodInvocation [
	^ methodInvocation
]

{ #category : #accessing }
InqCapturePoint >> methodInvocation: anObject [
	methodInvocation := anObject
]

{ #category : #printing }
InqCapturePoint >> printOn: aStream [
	aStream nextPutAll: 'CapturePoint(';
		nextPutAll: self capturedValue asString;
		nextPutAll: ', ';
		nextPutAll: self methodInvocation asStringForCapturePointsTable;
		nextPutAll: ')'
	
]

{ #category : #accessing }
InqCapturePoint >> receiver [
	^ receiver
]

{ #category : #accessing }
InqCapturePoint >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
InqCapturePoint >> timeIndex [
	^ timeIndex
]

{ #category : #accessing }
InqCapturePoint >> timeIndex: anObject [
	timeIndex := anObject
]
