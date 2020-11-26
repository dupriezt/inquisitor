Class {
	#name : #InqHitCheckTest,
	#superclass : #InqInquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #running }
InqHitCheckTest >> dummyForTestHitCheck [
	| i |
	i := 4.
	[ i = 0 ] whileFalse: [ i := i - 1 ].
]

{ #category : #running }
InqHitCheckTest >> testHitCheckNotAffectedByOtherBreakpoints [
	| oneHitNode fourHitNode q b |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestHitCheck.
	
	fourHitNode := ((inquisitedMethod ast body statements at: 2) arguments at: 1) body statements at: 1.
	"Install breakpoint on another node of the method, as if the user had set a manual breakpoint there"
	b := Breakpoint new node: fourHitNode; always; install.
	breakpoints add: b.
	
	oneHitNode := inquisitedMethod ast body statements at: 1.
	q := InqHitCheckQuestion newForNode: oneHitNode.
	q askToInquisitor: inquisitor.
	self assert: q capturePoints size equals: 1.
]

{ #category : #running }
InqHitCheckTest >> testHitCheck_FourHit [
	| fourHitNode q |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestHitCheck.
	
	fourHitNode :=  ((inquisitedMethod ast body statements at: 2) arguments at: 1) body statements at: 1. "'i := i - 1' assignment node"
	q := InqHitCheckQuestion newForNode: fourHitNode.
	q askToInquisitor: inquisitor.
	self assert: q capturePoints size equals: 4.
]

{ #category : #running }
InqHitCheckTest >> testHitCheck_OneHit [
	| oneHitNode q |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestHitCheck.
	
	oneHitNode := inquisitedMethod ast body statements at: 1. "'i := 4' assignment node"
	q := InqHitCheckQuestion newForNode: oneHitNode.
	q askToInquisitor: inquisitor.
	self assert: q capturePoints size equals: 1.
]
