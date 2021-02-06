Class {
	#name : #InqCapturePointTest,
	#superclass : #InqInquisitorTest,
	#instVars : [
		'astCacheCopy'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #'helper methods' }
InqCapturePointTest >> assertBreakException: aBreakException isADebuggerOpenOnMethod: aCompiledMethod [
	| debuggerContext breakNode |
	debuggerContext := aBreakException signalerContext sender. "Context on which the debugger opens"
	self assert: debuggerContext method name equals: aCompiledMethod name.
	breakNode := debuggerContext currentNode. "Current AST node being executed by debuggerContext. It should be the #breakInContext:node: message node introduced into the method by the breakpoint. We check this now:"
	self assert: breakNode isMessage.
	self assert: breakNode selector = #breakInContext:node:.
]

{ #category : #'helper methods' }
InqCapturePointTest >> breakExceptionToHighlightedNodeInDebugger: aBreakException [
	"Take a Break exception. Return the ast node that would be highlighted if that exception was opened in a debugger"
	| debuggerContext breakNode |
	debuggerContext := aBreakException signalerContext sender. "Context on which the debugger opens"
	breakNode := debuggerContext currentNode. "Current AST node being executed by debuggerContext. It should be the #breakInContext:node: message node introduced into the method by the breakpoint"
	^ breakNode parent. "Node currently highlighted in the debugger"
]

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
	"Disabling the breakpoint on which the capture point was created, because that's what the inquisitor questions do"
	b1 disable.
	b2 disable.
	^ capturePoint
	
]

{ #category : #'helper methods' }
InqCapturePointTest >> createCapturePointOnNode: aNode Capturing: aValue whenExecuting: aBlock [
	"Set a breakpoint on @aNode. Run @aBlock (which is expected to reach @aNode) to trigger the breakpoint. Create a CapturePoint capturing @aValue on that breakpoint hit."
	| capturePoint b |
	b := Breakpoint new node: aNode; always; install; yourself.
	breakpoints add: b. "So that tearDown removes the breakpoint"
	
	[aBlock on: Break do: [ :ex | capturePoint := InqCapturePointFactory new newCapturePointForContext: (ex signalerContext sender "context of the method in which the breakpoint was installed") andCapturedValue: aValue andBreakpointsEncountered: (OrderedCollection new add: b; yourself)]] on: Halt do: [ :ex | ex resume. "Ignore Halt exceptions raised by the execution. InqInquisitorQuestions have a mechanism to ignore halts in the same way" ].
	
	b disable. "Disabling the breakpoint on which the capture point was created, because that's what the inquisitor questions do"
	capturePoint ifNil: [ self error: 'No capture point was created. The execution above probably did not trigger a Break exception to enter the handler above' ].
	^ capturePoint
]

{ #category : #'helper methods' }
InqCapturePointTest >> createSimpleCapturePointCapturing: aValue [
	"Create a CapturePoint capturing @aValue. This CapturePoint encounters a single breakpoint: the one on the 'self breakpointTarget' node of CapturePointTest>>#dummyMethod"
	| capturePoint b |
	self setUpForInquisitedMethod: InqCapturePointTest>>#dummyMethod.

	b := self installBreakpointAtFirstBreakpointTargetInMethod: inquisitedMethod.
	[ self dummyMethod ] on: Break do: [ :ex | capturePoint := InqCapturePointFactory new newCapturePointForContext:  (ex signalerContext sender "context of dummyMethod") andCapturedValue: aValue andBreakpointsEncountered: (OrderedCollection new add: b; yourself)].
	b disable. "Disabling the breakpoint on which the capture point was created, because that's what the inquisitor questions do"
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
InqCapturePointTest >> dummyMethodWithHalt [
	<haltOrBreakpointForTesting>
	Point x:1 y:2.
	self halt.
	self breakpointTarget.
]

{ #category : #'helper methods' }
InqCapturePointTest >> getBreakpointTargetNodeOf: aCompiledMethod [
	"Return the first 'self breakpointTarget' message node of @aCompiledMethod"
	^ aCompiledMethod ast allChildren detect: [ :node | node isMessage and: [ node selector = #breakpointTarget ] ].
]

{ #category : #'helper methods' }
InqCapturePointTest >> installBreakpointAtFirstBreakpointTargetInMethod: aCompiledMethod [
	| targetNode breakpoint |
	targetNode := aCompiledMethod ast allChildren detect: [ :node | node isMessage and: [ node selector = #breakpointTarget ] ].
	breakpoint := Breakpoint new node: targetNode; always; install; yourself.
	breakpoints add: breakpoint. "So that tearDown removes the breakpoint"
	^ breakpoint
]

{ #category : #running }
InqCapturePointTest >> setUp [
	super setUp.
	breakpoints := OrderedCollection new.
	"Empties the instance registers of the assist classes"
	self assistClasses do: [ :assistClass | assistClass clearInstances ].
	"Capture initial state of assist classes, so that it can be asserted later that they were not modified by the tests"
	assistClassesInitialStateDictionary := Dictionary new.
	self assistClasses do: [ :assistClass | |d|
		d := Dictionary new.
		assistClassesInitialStateDictionary at: assistClass put: d.
		self captureInitialStateOfAssistClass: assistClass inDictionary: d
	].
	astCacheCopy := ASTCache default copy.
]

{ #category : #running }
InqCapturePointTest >> tearDown [
	ASTCache default: astCacheCopy.
	super tearDown.
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
	
	self postTestAssertions
	
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
	
	self should: [[inquisitor openExecutionOnCapturePoint: capturePoint] on: Break do: [ :ex |
		debuggerContext := ex signalerContext sender. "Context on which the debugger opens"
		self assert: debuggerContext method name equals: 'InqCapturePointTest>>#dummyMethodA2'.
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

	self postTestAssertions
]

{ #category : #'helper methods' }
InqCapturePointTest >> testOpenCapturePointWithHalt [
	"Test that opening a capture point works and opens a debugger at the right place when there is a halt in the execution that is being re-executed"
	| cp openNode |
	self setUpForInquisitedMethod: ((self class)>>#dummyMethodWithHalt).
	cp := self createCapturePointOnNode: (self getBreakpointTargetNodeOf: inquisitedMethod) Capturing: nil whenExecuting: [ self perform: inquisitedMethod selector ].
	
	"Opening the capture point should raise a Break (that would normally open a debugger as required by the user), but should ignore the Halt of #dummyMethodWithHalt and not raise it"
	self shouldnt: [[inquisitor openExecutionOnCapturePoint: cp] on: Break do: [ :ex |
		self assertBreakException: ex isADebuggerOpenOnMethod: inquisitedMethod.
		openNode := self breakExceptionToHighlightedNodeInDebugger: ex.
		self assert: openNode isMessage.
		self assert: openNode selector = #breakpointTarget.
		^ 'Test passed'
	]] raise: Halt.

	self postTestAssertions
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

	self postTestAssertions
]

{ #category : #'helper methods' }
InqCapturePointTest >> testOpenSimpleCapturePointAfterCleaningASTCache [
	"Creates a CapturePoint and use Inquisitor>>#openExecutionOnCapturePoint: to run the inquisited execution up until it reaches this capture point. Cleans the AST cache, which can mess with breakpoints. Checks that the execution signals a Break exception that would open a debugger on the right node.
	The CapturePoint is 'simple' in that there is only one breakpoint to go through to reach it."
	| capturePoint debuggerContext node breakNode |
	capturePoint := self createSimpleCapturePointCapturing: nil.
	"Clean the AST cache"
	ASTCache default reset.

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

	self postTestAssertions
]
