"
Inherits from OrderedCollection to have the behaviour that two MethodInvocation are = if their contextHash and invokedMethod are the same.
contextHash is stored as the first element of this collection.
invokedMethod is stored as the second one
"
Class {
	#name : #InqMethodInvocation,
	#superclass : #OrderedCollection,
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqMethodInvocation class >> newForContext: aContext [
	^ self newForContextHash: (aContext hash) andContextMethod: (aContext method)
]

{ #category : #'instance creation' }
InqMethodInvocation class >> newForContextHash: anInteger andContextMethod: aCompiledMethod [
	^ self new add: anInteger; add: aCompiledMethod; yourself
]

{ #category : #converting }
InqMethodInvocation >> asStringForCapturePointsTable [
	"Returns a string describing me"
	^ String streamContents: [ :stream | stream
		nextPutAll: (self contextHash asString);
		nextPutAll: ' '.
		self invokedMethod printOn: stream	
	]
]

{ #category : #accessing }
InqMethodInvocation >> contextHash [
	^ self at: 1
]

{ #category : #accessing }
InqMethodInvocation >> invokedMethod [
	^ self at: 2
]
