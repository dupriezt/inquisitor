Class {
	#name : #InqHitCheckTest,
	#superclass : #InqInquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #asserting }
InqHitCheckTest >> assertNoBreakpointInAssistMethodAfterTest [
	self deny: self hasBreakpointsInAssistMethods description: 'This test left a breakpoint in the assist method'
]

{ #category : #asserting }
InqHitCheckTest >> assertNoBreakpointInAssistMethodBeforeTest [
	self deny: self hasBreakpointsInAssistMethods description: 'There was a breakpoint in the assist method before this test'
]

{ #category : #running }
InqHitCheckTest >> assistMethod [
	^ self class>>#dummyForTestHitCheck
]

{ #category : #running }
InqHitCheckTest >> dummyForTestHitCheck [
	| i |
	i := 4.
	[ i = 0 ] whileFalse: [ i := i - 1 ].
]

{ #category : #running }
InqHitCheckTest >> hasBreakpointsInAssistMethods [
	^ self assistMethod hasBreakpoint
]

{ #category : #running }
InqHitCheckTest >> testHitCheckNotAffectedByOtherBreakpoints [
	| oneHitNode fourHitNode q b |
	self assertNoBreakpointInAssistMethodBeforeTest. 
	self setUpForInquisitedMethod: (self class)>>#dummyForTestHitCheck.
	
	fourHitNode := ((inquisitedMethod ast body statements at: 2) arguments at: 1) body statements at: 1.
	"Install breakpoint on another node of the method, as if the user had set a manual breakpoint there"
	b := Breakpoint new node: fourHitNode; always; install.
	breakpoints add: b.
	
	oneHitNode := inquisitedMethod ast body statements at: 1.
	q := InqHitCheckQuestion newForNode: oneHitNode.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	self assert: q capturePoints size equals: 1.
	"self assertNoBreakpointInAssistMethodAfterTest. It is normal that there is a breakpoint in the assist method after this test. The tearDown should remove it."
]

{ #category : #running }
InqHitCheckTest >> testHitCheck_FourHit [
	| fourHitNode q |
	self assertNoBreakpointInAssistMethodBeforeTest.
	self setUpForInquisitedMethod: (self class)>>#dummyForTestHitCheck.
	
	fourHitNode :=  ((inquisitedMethod ast body statements at: 2) arguments at: 1) body statements at: 1. "'i := i - 1' assignment node"
	q := InqHitCheckQuestion newForNode: fourHitNode.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	self assert: q capturePoints size equals: 4.
	self assertNoBreakpointInAssistMethodAfterTest.
]

{ #category : #running }
InqHitCheckTest >> testHitCheck_OneHit [
	| oneHitNode q |
	self assertNoBreakpointInAssistMethodBeforeTest.
	self setUpForInquisitedMethod: (self class)>>#dummyForTestHitCheck.
	
	oneHitNode := inquisitedMethod ast body statements at: 1. "'i := 4' assignment node"
	q := InqHitCheckQuestion newForNode: oneHitNode.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	self assert: q capturePoints size equals: 1.
	self assertNoBreakpointInAssistMethodAfterTest.
]
