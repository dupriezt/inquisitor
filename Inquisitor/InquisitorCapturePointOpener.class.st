Class {
	#name : #InquisitorCapturePointOpener,
	#superclass : #Object,
	#instVars : [
		'inquisitor',
		'capturePoint'
	],
	#classVars : [
		'mainInstance'
	],
	#category : #Inquisitor
}

{ #category : #accessing }
InquisitorCapturePointOpener >> capturePoint [
	^ capturePoint
]

{ #category : #accessing }
InquisitorCapturePointOpener >> capturePoint: anObject [
	capturePoint := anObject
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
InquisitorCapturePointOpener >> open [
	"Run the execution on which @inquisitor is based, until @capturePoint is reached, and open it in a debugger"
	capturePoint breakpointsEncountered do: [ :brkpt | brkpt install ].
	self halt.
]
