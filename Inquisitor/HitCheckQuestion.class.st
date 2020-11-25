Class {
	#name : #HitCheckQuestion,
	#superclass : #InquisitorQuestion,
	#category : #Inquisitor
}

{ #category : #'instance creation' }
HitCheckQuestion class >> newForNode: aRBProgramNode [
	^ self new node: aRBProgramNode; yourself
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> askToInquisitor: anInquisitor [
	| b |
	b := Breakpoint new node: node; always; install.
	self breakpoints add: b.
	self runExecutionWithInquisitor: anInquisitor.
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> resultDescription [
	^ self capturePoints size asString, ' hits of ''', node sourceCode asString, ''' in ', self fullMethodNameOfNode
]

{ #category : #'as yet unclassified' }
HitCheckQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	| cp | 
	self breakpointsEncountered add: aBreakpoint.
	cp := self capturePointFactory newCapturePointForContext: (aBreakException signalerContext sender) andCapturedValue: nil andBreakpointsEncountered: self breakpointsEncountered copy.
	self capturePoints add: cp.
]
