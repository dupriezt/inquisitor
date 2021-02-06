Class {
	#name : #InqVariableValueHistoryTest,
	#superclass : #InqInquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #running }
InqVariableValueHistoryTest >> assistClass [
	"Class used as dummy by the tests"
	^ InqTestAssistClassForVariableHistoryQuestion
]

{ #category : #running }
InqVariableValueHistoryTest >> assistClasses [ 
	^ OrderedCollection new add: InqTestAssistClassForVariableHistoryQuestion; yourself
]

{ #category : #running }
InqVariableValueHistoryTest >> dummyForTestVariableValueHistory_ArgumentVariables [
	(self assistClass) new methodWithArgument: 0; methodWithArgument: 1.
	(self assistClass) new methodWithArgument: 10.
]

{ #category : #running }
InqVariableValueHistoryTest >> dummyForTestVariableValueHistory_ClassVariable [
	(self assistClass) setClassVariableTo: 0; setClassVariableTo: 1.
	(self assistClass) setClassVariableTo: 2.
]

{ #category : #running }
InqVariableValueHistoryTest >> dummyForTestVariableValueHistory_InstanceVariable [
	(self assistClass) new setInstanceVariableTo: 0; setInstanceVariableTo: 1.
	(self assistClass) new setInstanceVariableTo: 2.
]

{ #category : #running }
InqVariableValueHistoryTest >> dummyForTestVariableValueHistory_LocalVariable [
	(self assistClass) new setLocalVariables; setLocalVariables.
	(self assistClass) new setLocalVariables.
]

{ #category : #running }
InqVariableValueHistoryTest >> tearDown [
	super tearDown.
]

{ #category : #running }
InqVariableValueHistoryTest >> testVariableValueHistory_ArgumentVariables [
	| questionedMethod argumentOneNode q cps inst1 inst2 qMeth |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestVariableValueHistory_ArgumentVariables.
	
	questionedMethod := (self assistClass)>>#methodWithArgument:.
	argumentOneNode := questionedMethod ast arguments at: 1. "Argument named arg1"
	q := InqArgumentVariableValueHistoryQuestion newForNode: argumentOneNode andMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	cps := q capturePoints.
	self assert: cps size equals: 3.
	"Asserts that all three capture points are on different method invocations"
	self assertCollection: (cps collect: [:cp | cp methodInvocation contextHash]) matchesPattern: { #a. #b. #c }.
	self assert: self assistClass instances size equals: 2.
	inst1 := self assistClass instances first.
	inst2 := self assistClass instances second.
	qMeth := questionedMethod.
	self assertCapturePoint: (cps at: 1) value: 0 receiver: inst1 method: qMeth nbBreakpoints: 1.
	self assertCapturePoint: (cps at: 2) value: 1 receiver: inst1 method: qMeth nbBreakpoints: 2.
	self assertCapturePoint: (cps at: 3) value: 10 receiver: inst2 method: qMeth nbBreakpoints: 3.
	
	self removeBreakpointsOfQuestion: q.
	self postTestAssertions.
]

{ #category : #running }
InqVariableValueHistoryTest >> testVariableValueHistory_ClassVariables [
	| questionedMethod classVariableNode q cps qMeth varOwner |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestVariableValueHistory_ClassVariable.
	
	"In this test, the questionedMethod (method owning the variable ast node on which the question is asked) is the same as the method that the dummy execution will use to change the value of the variable (i.e. the method whose invocations will end up in capture points). These two methods do not have to be the same."
	questionedMethod := (self assistClass class)>>#setClassVariableTo:.
	classVariableNode := (questionedMethod ast body statements at: 1) variable. "Class variable named: myClassVariable"
	q := InqClassVariableValueHistoryQuestion newForNode: classVariableNode andMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	cps := q capturePoints.
	self assert: cps size equals: 3.
	"Asserts that all three capture points are on different method invocations"
	self assertCollection: (cps collect: [:cp | cp methodInvocation contextHash]) matchesPattern: { #a. #b. #c }.
	varOwner := self assistClass.
	qMeth := questionedMethod.
	self assertCapturePoint: (cps at: 1) value: 0 receiver: varOwner method: qMeth nbBreakpoints: 1.
	self assertCapturePoint: (cps at: 2) value: 1 receiver: varOwner method: qMeth nbBreakpoints: 2.
	self assertCapturePoint: (cps at: 3) value: 2 receiver: varOwner method: qMeth nbBreakpoints: 3.
	
	self removeBreakpointsOfQuestion: q.
	self postTestAssertions.
]

{ #category : #running }
InqVariableValueHistoryTest >> testVariableValueHistory_InstanceVariables [
	| questionedMethod instanceVariableNode q cps inst1 inst2 qMeth |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestVariableValueHistory_InstanceVariable.
	
	"In this test, the questionedMethod (method owning the variable ast node on which the question is asked) is the same as the method that the dummy execution will use to change the value of the variable (i.e. the method whose invocations will end up in capture points). These two methods do not have to be the same."
	questionedMethod := (self assistClass)>>#setInstanceVariableTo:.
	instanceVariableNode := (questionedMethod ast body statements at: 1) variable. "Instance variable named: myInstanceVariable"
	q := InqInstanceVariableValueHistoryQuestion newForNode: instanceVariableNode andMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	cps := q capturePoints.
	self assert: cps size equals: 3.
	"Asserts that all three capture points are on different method invocations"
	self assertCollection: (cps collect: [:cp | cp methodInvocation contextHash]) matchesPattern: { #a. #b. #c }.
	self assert: self assistClass instances size equals: 2.
	inst1 := self assistClass instances first.
	inst2 := self assistClass instances second.
	qMeth := questionedMethod.
	self assertCapturePoint: (cps at: 1) value: 0 receiver: inst1 method: qMeth nbBreakpoints: 1.
	self assertCapturePoint: (cps at: 2) value: 1 receiver: inst1 method: qMeth nbBreakpoints: 2.
	self assertCapturePoint: (cps at: 3) value: 2 receiver: inst2 method: qMeth nbBreakpoints: 3.
	
	self removeBreakpointsOfQuestion: q.
	self postTestAssertions.
]

{ #category : #running }
InqVariableValueHistoryTest >> testVariableValueHistory_LocalVariable [
	| localVariableNode questionedMethod cps inst1 inst2 qMeth q |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestVariableValueHistory_LocalVariable.
	
	questionedMethod := (self assistClass)>>#setLocalVariables.
	localVariableNode := (questionedMethod ast body statements at: 1) variable. "local variable #a"
	q := InqLocalVariableValueHistoryQuestion newForNode: localVariableNode andMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	cps := q capturePoints.
	self assert: cps size equals: 9.
	"Asserts that the first three capture points are on the same method invocation, that the next three are on another method invocation, and that the final three are on a third method invocation"
	self assertCollection: (cps collect: [:cp | cp methodInvocation contextHash]) matchesPattern: { #a. #a. #a. #b. #b. #b. #c. #c. #c }.
	self assert: self assistClass instances size equals: 2.
	inst1 := self assistClass instances first.
	inst2 := self assistClass instances second.
	qMeth := questionedMethod.
	self assertCapturePoint: (cps at: 1) value: 0 receiver: inst1 method: qMeth nbBreakpoints: 1.
	self assertCapturePoint: (cps at: 2) value: 1 receiver: inst1 method: qMeth nbBreakpoints: 2.
	self assertCapturePoint: (cps at: 3) value: 2 receiver: inst1 method: qMeth nbBreakpoints: 3.
	self assertCapturePoint: (cps at: 4) value: 0 receiver: inst1 method: qMeth nbBreakpoints: 4.
	self assertCapturePoint: (cps at: 5) value: 1 receiver: inst1 method: qMeth nbBreakpoints: 5.
	self assertCapturePoint: (cps at: 6) value: 2 receiver: inst1 method: qMeth nbBreakpoints: 6.
	self assertCapturePoint: (cps at: 7) value: 0 receiver: inst2 method: qMeth nbBreakpoints: 7.
	self assertCapturePoint: (cps at: 8) value: 1 receiver: inst2 method: qMeth nbBreakpoints: 8.
	self assertCapturePoint: (cps at: 9) value: 2 receiver: inst2 method: qMeth nbBreakpoints: 9.
	
	self removeBreakpointsOfQuestion: q.
	self postTestAssertions.
]
