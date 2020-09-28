Class {
	#name : #HitCheckQuestion,
	#superclass : #InquisitorQuestion,
	#instVars : [
		'hitCount'
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
	b := Breakpoint new node: node.
	b always.
	b install.
	[anInquisitor runExecution] on: Break do: [ :ex| hitCount := hitCount + 1. ex resume. ].
	b remove.
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
