Class {
	#name : #HitCheckTest,
	#superclass : #InquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #running }
HitCheckTest >> dummyForTestHitCheck [
	| i |
	i := 4.
	[ i = 0 ] whileFalse: [ i := i - 1 ].
]

{ #category : #running }
HitCheckTest >> testHitCheckNotAffectedByOtherBreakpoints [
	| oneHitNode fourHitNode q b |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestHitCheck.
	
	fourHitNode := ((inquisitedMethod ast body statements at: 2) arguments at: 1) body statements at: 1.
	"Install breakpoint on another node of the method, as if the user had set a manual breakpoint there"
	b := Breakpoint new node: fourHitNode; always; install.
	breakpoints add: b.
	
	oneHitNode := inquisitedMethod ast body statements at: 1.
	q := HitCheckQuestion newForNode: oneHitNode.
	q askToInquisitor: inquisitor.
	self assert: q capturePoints size equals: 1.
]

{ #category : #running }
HitCheckTest >> testHitCheck_FourHit [
	| fourHitNode q |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestHitCheck.
	
	fourHitNode :=  ((inquisitedMethod ast body statements at: 2) arguments at: 1) body statements at: 1. "'i := i - 1' assignment node"
	q := HitCheckQuestion newForNode: fourHitNode.
	q askToInquisitor: inquisitor.
	self assert: q capturePoints size equals: 4.
]

{ #category : #running }
HitCheckTest >> testHitCheck_OneHit [
	| oneHitNode q |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestHitCheck.
	
	oneHitNode := inquisitedMethod ast body statements at: 1. "'i := 4' assignment node"
	q := HitCheckQuestion newForNode: oneHitNode.
	q askToInquisitor: inquisitor.
	self assert: q capturePoints size equals: 1.
]
