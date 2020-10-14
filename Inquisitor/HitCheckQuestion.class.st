Class {
	#name : #HitCheckQuestion,
	#superclass : #InquisitorQuestion,
	#instVars : [
		'hitCount',
		'breakpoint'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
HitCheckQuestion class >> newForNode: aRBProgramNode [
	^ self new node: aRBProgramNode; yourself
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> askToInquisitor: anInquisitor [
	hitCount := 0.
	Breakpoint registerObserver: self.
	breakpoint := Breakpoint new node: node.
	breakpoint always.
	breakpoint install.
	[anInquisitor runExecution] on: Break do: [ :ex| "hitCount := hitCount + 1." ex resume. ].
	breakpoint remove.
	Breakpoint unregisterObserver: self.
	anInquisitor addResolvedQuestion: self.
]

{ #category : #accessing }
HitCheckQuestion >> hitCount [
	^ hitCount
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
	^ hitCount
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> resultDescription [
	^ 'The execution encountered this node ', hitCount asString, ' times'
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> update: aNotification [
	"Called by the Breakpoint class when a breakpoint is hit/added/removed"
	aNotification isBreakpointHitNotification ifTrue: [
		(aNotification breakpoint = breakpoint) ifTrue: [ hitCount := hitCount + 1 ]
	]
]
