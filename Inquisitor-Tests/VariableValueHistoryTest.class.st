Class {
	#name : #VariableValueHistoryTest,
	#superclass : #InquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #running }
VariableValueHistoryTest >> assertCapturePoint: aCapturePoint value: aValue receiver: anObject method: aCompiledMethod nbBreakpoints: anInteger [
	self assert: aCapturePoint capturedValue equals: aValue.
	self assert: aCapturePoint receiver equals: anObject.
	"Checking equality on the names of the methods; and not on the methods themselves, because the compiled methods are sometimes different just because one contains bytecode for the breakpoint that was inserted into it"
	self assert: aCapturePoint methodInvocation invokedMethod name equals: aCompiledMethod name.
	self assert: aCapturePoint breakpointsEncountered size equals: anInteger
	
]

{ #category : #running }
VariableValueHistoryTest >> assertCollection: aCollection matchesPattern: patternCollection [
	"Asserts that @aCollection matches the pattern of @patternCollection.
	For example, collection { 1. 2. 2. 3 } matches the pattern: { #a. #b. #b. #c }.
	Both collections need to be ordered, and the elements of @patternCollection must be usable as keys in a dictionary
	"
	| patternAssignment pattern |
	patternAssignment := Dictionary new.
	self assert: aCollection size equals: patternCollection size.
	aCollection doWithIndex: [ :el :i | 
		pattern := patternCollection at: i.
		patternAssignment	at: pattern ifPresent: [:v | self assert: el equals: v ] ifAbsent: [ patternAssignment at: pattern put: el ]
	]
	
	
]

{ #category : #running }
VariableValueHistoryTest >> assistClass [
	"Class used as dummy by the tests"
	^ InquisitorTestVariableDummy
]

{ #category : #running }
VariableValueHistoryTest >> cleanAssistClass [
	self assistClass clearInstances
]

{ #category : #running }
VariableValueHistoryTest >> dummyForTestVariableValueHistory_ArgumentVariables [
	(self assistClass) new methodWithArgument: 0; methodWithArgument: 1.
	(self assistClass) new methodWithArgument: 10.
]

{ #category : #running }
VariableValueHistoryTest >> dummyForTestVariableValueHistory_ClassVariable [
	(self assistClass) setClassVariableTo: 0; setClassVariableTo: 1.
	(self assistClass) setClassVariableTo: 2.
]

{ #category : #running }
VariableValueHistoryTest >> dummyForTestVariableValueHistory_InstanceVariable [
	(self assistClass) new setInstanceVariableTo: 0; setInstanceVariableTo: 1.
	(self assistClass) new setInstanceVariableTo: 2.
]

{ #category : #running }
VariableValueHistoryTest >> dummyForTestVariableValueHistory_LocalVariable [
	(self assistClass) new setLocalVariables; setLocalVariables.
	(self assistClass) new setLocalVariables.
]

{ #category : #running }
VariableValueHistoryTest >> setUp [
	super setUp.
	self cleanAssistClass
]

{ #category : #running }
VariableValueHistoryTest >> testVariableValueHistory_ArgumentVariables [
	| questionedMethod argumentOneNode question cps inst1 inst2 qMeth |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestVariableValueHistory_ArgumentVariables.
	
	questionedMethod := (self assistClass)>>#methodWithArgument:.
	argumentOneNode := questionedMethod ast arguments at: 1. "Argument named arg1"
	question := ArgumentVariableValueHistoryQuestion newForNode: argumentOneNode andMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	cps := question capturePoints.
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
]

{ #category : #running }
VariableValueHistoryTest >> testVariableValueHistory_ClassVariables [
	| questionedMethod classVariableNode question cps qMeth varOwner |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestVariableValueHistory_ClassVariable.
	
	"In this test, the questionedMethod (method owning the variable ast node on which the question is asked) is the same as the method that the dummy execution will use to change the value of the variable (i.e. the method whose invocations will end up in capture points). These two methods do not have to be the same."
	questionedMethod := (self assistClass class)>>#setClassVariableTo:.
	classVariableNode := (questionedMethod ast body statements at: 1) variable. "Class variable named: myClassVariable"
	question := ClassVariableValueHistoryQuestion newForNode: classVariableNode andMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	cps := question capturePoints.
	self assert: cps size equals: 3.
	"Asserts that all three capture points are on different method invocations"
	self assertCollection: (cps collect: [:cp | cp methodInvocation contextHash]) matchesPattern: { #a. #b. #c }.
	varOwner := self assistClass.
	qMeth := questionedMethod.
	self assertCapturePoint: (cps at: 1) value: 0 receiver: varOwner method: qMeth nbBreakpoints: 1.
	self assertCapturePoint: (cps at: 2) value: 1 receiver: varOwner method: qMeth nbBreakpoints: 2.
	self assertCapturePoint: (cps at: 3) value: 2 receiver: varOwner method: qMeth nbBreakpoints: 3.
]

{ #category : #running }
VariableValueHistoryTest >> testVariableValueHistory_InstanceVariables [
	| questionedMethod instanceVariableNode question cps inst1 inst2 qMeth |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestVariableValueHistory_InstanceVariable.
	
	"In this test, the questionedMethod (method owning the variable ast node on which the question is asked) is the same as the method that the dummy execution will use to change the value of the variable (i.e. the method whose invocations will end up in capture points). These two methods do not have to be the same."
	questionedMethod := (self assistClass)>>#setInstanceVariableTo:.
	instanceVariableNode := (questionedMethod ast body statements at: 1) variable. "Instance variable named: myInstanceVariable"
	question := InstanceVariableValueHistoryQuestion newForNode: instanceVariableNode andMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	cps := question capturePoints.
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
]

{ #category : #running }
VariableValueHistoryTest >> testVariableValueHistory_LocalVariable [
	| localVariableNode questionedMethod cps inst1 inst2 qMeth question |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestVariableValueHistory_LocalVariable.
	
	questionedMethod := (self assistClass)>>#setLocalVariables.
	localVariableNode := (questionedMethod ast body statements at: 1) variable. "local variable #a"
	question := LocalVariableValueHistoryQuestion newForNode: localVariableNode andMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	cps := question capturePoints.
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
]
