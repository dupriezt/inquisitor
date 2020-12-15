Class {
	#name : #InqHitCheckQuestion,
	#superclass : #InqInquisitorQuestion,
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqHitCheckQuestion class >> newForNode: aRBProgramNode [
	^ self new node: aRBProgramNode; yourself
]

{ #category : #'as yet unclassified' }
InqHitCheckQuestion >> askToInquisitor: anInquisitor [
	| b |
	b := Breakpoint new node: node; always; install.
	self breakpoints add: b.
	self runExecutionWithInquisitor: anInquisitor.
]

{ #category : #'as yet unclassified' }
InqHitCheckQuestion >> name [
	^ 'HitCheck'
]

{ #category : #'as yet unclassified' }
InqHitCheckQuestion >> resultDescription [
	^ self capturePoints size asString, ' hits of ''', node sourceCode asString, ''' in ', self fullMethodNameOfNode
]

{ #category : #'as yet unclassified' }
InqHitCheckQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	| cp | 
	self breakpointsEncountered add: aBreakpoint.
	cp := self capturePointFactory newCapturePointForContext: (aBreakException signalerContext sender) andCapturedValue: nil andBreakpointsEncountered: self breakpointsEncountered copy.
	self capturePoints add: cp.
]
