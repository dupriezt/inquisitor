Class {
	#name : #InqCapturePointTest,
	#superclass : #InqInquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #'helper methods' }
InqCapturePointTest >> breakpointTarget [
	"Does nothing. Used in dummy methods to mark locations to place breakpoints at"
	^ self
]

{ #category : #'helper methods' }
InqCapturePointTest >> createCapturePointCapturing: aValue [
	"Create a CapturePoint capturing @aValue. List of breakpoints this CapturePoint encounters:
	- 'self breakpointTarget' node of CapturePointTest>>#dummyMethodA1 (1 time)
	- 'self breakpointTarget' node of CapturePointTest>>#dummyMethodA2 (3 times)"
	| capturePoint b1 b2 nbBreakpointEncounter |
	self setUpForInquisitedMethod: InqCapturePointTest>>#dummyMethodA1.

	b1 := self installBreakpointAtFirstBreakpointTargetInMethod: inquisitedMethod.
	b2 := self installBreakpointAtFirstBreakpointTargetInMethod: InqCapturePointTest>>#dummyMethodA2.
	nbBreakpointEncounter := 0.
	[ self dummyMethodA1 ] on: Break do: [ :ex |
		nbBreakpointEncounter := nbBreakpointEncounter + 1.
		(nbBreakpointEncounter = 4) ifFalse: [ex resume] ifTrue: [ 
			"The execution should have encountered b1 once and b2 thrice"
			capturePoint := InqCapturePointFactory new newCapturePointForContext:  (ex signalerContext sender "context of dummyMethodA2") andCapturedValue: aValue andBreakpointsEncountered: (OrderedCollection new add: b1; add: b2; add: b2; add: b2; yourself)
		]
	].
	self removeBreakpoints. "Removing the breakpoints we introduced to create @capturePoint, to avoid polluting tests about opening @capturePoint"
	^ capturePoint
	
]

{ #category : #'helper methods' }
InqCapturePointTest >> createSimpleCapturePointCapturing: aValue [
	"Create a CapturePoint capturing @aValue. This CapturePoint encounters a single breakpoint: the one on the 'self breakpointTarget' node of CapturePointTest>>#dummyMethod"
	| capturePoint b |
	self setUpForInquisitedMethod: InqCapturePointTest>>#dummyMethod.

	b := self installBreakpointAtFirstBreakpointTargetInMethod: inquisitedMethod.
	[ self dummyMethod ] on: Break do: [ :ex | capturePoint := InqCapturePointFactory new newCapturePointForContext:  (ex signalerContext sender "context of dummyMethod") andCapturedValue: aValue andBreakpointsEncountered: (OrderedCollection new add: b; yourself)].
	self removeBreakpoints. "Removing the breakpoints we introduced to create @capturePoint, to avoid polluting tests about opening @capturePoint"
	^ capturePoint
	
]

{ #category : #'helper methods' }
InqCapturePointTest >> dummyMethod [
	Point x:1 y:2.
	self breakpointTarget.
]

{ #category : #'helper methods' }
InqCapturePointTest >> dummyMethodA1 [
	self breakpointTarget.
	self dummyMethodA2
]

{ #category : #'helper methods' }
InqCapturePointTest >> dummyMethodA2 [
	| i |
	i := 0.
	[ i = 4 ] whileFalse: [ i := i + 1. self breakpointTarget ].
]

{ #category : #'helper methods' }
InqCapturePointTest >> installBreakpointAtFirstBreakpointTargetInMethod: aCompiledMethod [
	| targetNode breakpoint |
	targetNode := aCompiledMethod ast allChildren detect: [ :node | node isMessage and: [ node selector = #breakpointTarget ] ].
	breakpoint := Breakpoint new node: targetNode; always; install; yourself.
	breakpoints add: breakpoint. "So that tearDown removes the breakpoint"
	^ breakpoint
]

{ #category : #'helper methods' }
InqCapturePointTest >> testCreateCapturePoint [
	"Creates a CapturePoint and checks its content"
	| capturePoint valueToCapture |
	valueToCapture := 42. "Exat value does not matter"
	capturePoint := self createSimpleCapturePointCapturing: valueToCapture.

	self assert: capturePoint isNotNil.
	self assert: capturePoint timeIndex equals: 1.
	self assert: capturePoint capturedValue equals: valueToCapture.
	self assert: capturePoint receiver identicalTo: self.
	self assert: capturePoint methodInvocation invokedMethod name equals: inquisitedMethod name. "Their names are equal, but these two CompiledMethod are not equal, because invokedMethod is the method with a breakpoint in it, while inquisitedMethod is the method before a breakpoint was put in it"
	
]

{ #category : #'helper methods' }
InqCapturePointTest >> testOpenCapturePoint [
	"Creates a CapturePoint and use Inquisitor>>#openExecutionOnCapturePoint: to run the inquisited execution up until it reaches this capture point. Checks that the execution signals a Break exception that would open a debugger on the right node."
	| capturePoint debuggerContext node breakNode breakpointsEncountered |
	capturePoint := self createCapturePointCapturing: nil.
	
	"Checking that the capture point has the expected breakpoints encountered"
	breakpointsEncountered := capturePoint breakpointsEncountered.
	self assert: breakpointsEncountered size equals: 4.
	self assert: breakpointsEncountered first node methodNode selector equals: #dummyMethodA1.
	self assert: breakpointsEncountered second node methodNode selector equals: #dummyMethodA2.
	self assert: breakpointsEncountered second equals: breakpointsEncountered third.
	self assert: breakpointsEncountered third equals: breakpointsEncountered fourth.
	
	"Checking that the methods that will be ran when opening @capturePoint do not have breakpoints"
	self deny: (InqCapturePointTest>>#dummyMethodA1) hasBreakpoint.
	self deny: (InqCapturePointTest>>#dummyMethodA2) hasBreakpoint.
	
	self should: [[inquisitor openExecutionOnCapturePoint: capturePoint] on: Break do: [ :ex |
		debuggerContext := ex signalerContext sender. "Context on which the debugger opens"
		self assert: debuggerContext method name equals: 'CapturePointTest>>#dummyMethodA2'.
		breakNode := debuggerContext currentNode. "Current AST node being executed by debuggerContext. It should be the #breakInContext:node: message node introduced into the method by the breakpoint"
		self assert: breakNode isMessage.
		self assert: breakNode selector = #breakInContext:node:.
		node := breakNode parent. "Node currently highlighted in the debugger"
		self assert: node isMessage.
		self assert: node selector equals: #breakpointTarget.
		"Checking that the capture point opened the execution at the correct iteration of the while loop ('i' is the name of the counter used in that loop)"
		self assert: (debuggerContext tempNamed: #i) equals: 3.
		ex pass.
	]] raise: Break.
]

{ #category : #'helper methods' }
InqCapturePointTest >> testOpenSimpleCapturePoint [
	"Creates a CapturePoint and use Inquisitor>>#openExecutionOnCapturePoint: to run the inquisited execution up until it reaches this capture point. Checks that the execution signals a Break exception that would open a debugger on the right node.
	The CapturePoint is 'simple' in that there is only one breakpoint to go through to reach it."
	| capturePoint debuggerContext node breakNode |
	capturePoint := self createSimpleCapturePointCapturing: nil.

	self should: [[inquisitor openExecutionOnCapturePoint: capturePoint] on: Break do: [ :ex |
		debuggerContext := ex signalerContext sender. "Context on which the debugger opens"
		self assert: debuggerContext method name equals: inquisitedMethod name.
		breakNode := debuggerContext currentNode. "Current AST node being executed by debuggerContext. It should be the #breakInContext:node: message node introduced into the method by the breakpoint"
		self assert: breakNode isMessage.
		self assert: breakNode selector = #breakInContext:node:.
		node := breakNode parent. "Node currently highlighted in the debugger"
		self assert: node isMessage.
		self assert: node selector equals: #breakpointTarget.
		ex pass.
	]] raise: Break.
]
