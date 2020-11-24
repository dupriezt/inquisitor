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
	InquisitorTestVariableDummy new methodWithArgument: 0; methodWithArgument: 1.
	InquisitorTestVariableDummy new methodWithArgument: 10.
]

{ #category : #running }
VariableValueHistoryTest >> dummyForTestVariableValueHistory_InstanceVariable [
	InquisitorTestVariableDummy new setInstanceVariableTo: 0; setInstanceVariableTo: 1.
	InquisitorTestVariableDummy new setInstanceVariableTo: 2.
]

{ #category : #running }
VariableValueHistoryTest >> dummyForTestVariableValueHistory_LocalVariable [
	InquisitorTestVariableDummy new setLocalVariables; setLocalVariables.
	InquisitorTestVariableDummy new setLocalVariables.
]

{ #category : #running }
VariableValueHistoryTest >> setUp [
	super setUp.
	self cleanAssistClass
]

{ #category : #running }
VariableValueHistoryTest >> testVariableValueHistory_ArgumentVariables [
	| instances questionedMethod argumentOneNode q a invocationsToValueHistory1 invocationsToValueHistory2 valueHistoryOfInvocation1 valueHistoryOfInvocation2 valueHistoryOfInvocation3 |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestVariableValueHistory_ArgumentVariables.
	
	questionedMethod := (self assistClass)>>#methodWithArgument:.
	argumentOneNode := questionedMethod ast arguments at: 1.
	q := ArgumentVariableValueHistoryQuestion newForNode: argumentOneNode andMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	a := inquisitor questionHistory last at: #a.
	instances := InquisitorTestVariableDummy instances.
	self assertCollection: a keys hasSameElements: instances.
	invocationsToValueHistory1 := a at: (instances at: 1).
	invocationsToValueHistory2 := a at: (instances at: 2).
	self assert: invocationsToValueHistory1 size equals: 2.
	self assert: invocationsToValueHistory2 size equals: 1.
	valueHistoryOfInvocation1 := invocationsToValueHistory1 at: (invocationsToValueHistory1 keys at: 1).
	valueHistoryOfInvocation2 := invocationsToValueHistory1 at: (invocationsToValueHistory1 keys at: 2).
	valueHistoryOfInvocation3 := invocationsToValueHistory2 at: (invocationsToValueHistory2 keys at: 1).
	self assertCollection: valueHistoryOfInvocation1 hasSameElements: {0}.
	self assertCollection: valueHistoryOfInvocation2 hasSameElements: {1}.
	self assertCollection: valueHistoryOfInvocation3 hasSameElements: {10}.
	
]

{ #category : #running }
VariableValueHistoryTest >> testVariableValueHistory_InstanceVariables [
	| instances questionedMethod q a invocationsToValueHistory1 invocationsToValueHistory2 valueHistoryOfInvocation1 valueHistoryOfInvocation2 valueHistoryOfInvocation3 instanceVariableNode |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestVariableValueHistory_InstanceVariable.
	
	questionedMethod := (self assistClass)>>#setInstanceVariableTo:.
	instanceVariableNode := (questionedMethod ast body statements at: 1) variable.
	q := InstanceVariableValueHistoryQuestion newForNode: instanceVariableNode andMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	a := inquisitor questionHistory last at: #a.
	instances := InquisitorTestVariableDummy instances.
	self assertCollection: a keys hasSameElements: instances.
	invocationsToValueHistory1 := a at: (instances at: 1).
	invocationsToValueHistory2 := a at: (instances at: 2).
	self assert: invocationsToValueHistory1 size equals: 2.
	self assert: invocationsToValueHistory2 size equals: 1.
	valueHistoryOfInvocation1 := invocationsToValueHistory1 at: (invocationsToValueHistory1 keys at: 1).
	valueHistoryOfInvocation2 := invocationsToValueHistory1 at: (invocationsToValueHistory1 keys at: 2).
	valueHistoryOfInvocation3 := invocationsToValueHistory2 at: (invocationsToValueHistory2 keys at: 1).
	self assertCollection: valueHistoryOfInvocation1 hasSameElements: {0}.
	self assertCollection: valueHistoryOfInvocation2 hasSameElements: {1}.
	self assertCollection: valueHistoryOfInvocation3 hasSameElements: {2}.
	
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
	self assertCollection: (cps collect: [:cp | cp methodInvocation contextHash]) matchesPattern: { #a. #a. #a. #b. #b. #b. #c. #c. #c }.
	"Todo: assert that the context hashes of the method invocations are of the form [a, a, a, b, b, b, c, c, c]"
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
