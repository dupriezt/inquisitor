Class {
	#name : #CapturePointTest,
	#superclass : #InquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #'helper methods' }
CapturePointTest >> createSimpleCapturePointCapturing: aValue [
	| capturePoint b |
	self setUpForInquisitedMethod: CapturePointTest>>#dummyMethod.

	b := Breakpoint new node: (inquisitedMethod ast body statements at: 2); always; install; yourself. "Node: 'Point new'"
	breakpoints add: b. "So that tearDown removes the breakpoint"
	[ self dummyMethod ] on: Break do: [ :ex | capturePoint := CapturePointFactory new newCapturePointForContext:  (ex signalerContext sender "context of dummyMethod") andCapturedValue: aValue andBreakpointsEncountered: (OrderedCollection new add: b; yourself)].

	^ capturePoint
	
]

{ #category : #'helper methods' }
CapturePointTest >> dummyMethod [
	Point x:1 y:2.
	Point new.
]

{ #category : #'helper methods' }
CapturePointTest >> testCreateCapturePoint [
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
CapturePointTest >> testOpenSimpleCapturePoint [
	"Creates a CapturePoint and use Inquisitor>>#openExecutionOnCapturePoint: to run the inquisited execution up until it reaches this capture point. Checks that the execution signals a Break exception that would open a debugger on the right node.
	The CapturePoint is 'simple' in that there is only one breakpoint to go through to reach it."
	| capturePoint valueToCapture debuggerContext node breakNode |
	valueToCapture := 42. "Exat value does not matter"
	capturePoint := self createSimpleCapturePointCapturing: valueToCapture.

	self should: [[inquisitor openExecutionOnCapturePoint: capturePoint] on: Break do: [ :ex |
		debuggerContext := ex signalerContext sender. "Context on which the debugger opens"
		self assert: debuggerContext method name equals: inquisitedMethod name.
		breakNode := debuggerContext currentNode. "Current AST node being executed by debuggerContext. It should be the #breakInContext:node: message node introduced into the method by the breakpoint"
		self assert: breakNode isMessage.
		self assert: breakNode selector = #breakInContext:node:.
		node := breakNode parent. "Node currently highlighted in the debugger"
		self assert: node isMessage.
		self assert: node selector equals: #new.
		ex pass.
	]] raise: Break.
]
