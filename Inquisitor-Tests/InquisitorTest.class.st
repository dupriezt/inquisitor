Class {
	#name : #InquisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'inquisitor',
		'inquisitedMethod'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #running }
InquisitorTest >> dummyForTestHitCheck [
	| i |
	i := 4.
	[ i = 0 ] whileFalse: [ i := i - 1 ].
]

{ #category : #running }
InquisitorTest >> dummyForTestVariableValueHistory_LocalVariable [
	InquisitorTestVariableDummy new setLocalVariables; setLocalVariables.
	InquisitorTestVariableDummy new setLocalVariables.
]

{ #category : #running }
InquisitorTest >> setUp [
	super setUp.
	inquisitor := Inquisitor new.
	inquisitor isSilent: true
]

{ #category : #running }
InquisitorTest >> setUpForInquisitedMethod: aCompiledMethod [
	inquisitedMethod := aCompiledMethod.
	inquisitor testClass: inquisitedMethod methodClass.
	inquisitor testMethodName: inquisitedMethod selector.
]

{ #category : #running }
InquisitorTest >> testHitCheck [
	| oneHitNode fourHitNode q1 q2 |
	self setUpForInquisitedMethod: InquisitorTest>>#dummyForTestHitCheck.
	
	oneHitNode := inquisitedMethod ast body statements at: 1.
	q1 := HitCheckQuestion newForNode: oneHitNode.
	q1 askToInquisitor: inquisitor.
	self assert: (inquisitor questionHistory last at: #a) equals: 1.
	
	fourHitNode :=  ((inquisitedMethod ast body statements at: 2) arguments at: 1) body statements at: 1.
	q2 := HitCheckQuestion newForNode: fourHitNode.
	q2 askToInquisitor: inquisitor.
	self assert: (inquisitor questionHistory last at: #a) equals: 4.
]

{ #category : #running }
InquisitorTest >> testVariableValueHistory_LocalVariable [
	| localVariableNode q a questionedMethod instance1 instance2 invocation1 invocation2 invocation3 |
	self setUpForInquisitedMethod: InquisitorTest>>#dummyForTestVariableValueHistory_LocalVariable.
	
	questionedMethod := InquisitorTestVariableDummy>>#setLocalVariables.
	localVariableNode := (questionedMethod ast body statements at: 1) variable.
	q := LocalVariableValueHistoryQuestion newForNode: localVariableNode andMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	a := inquisitor questionHistory last at: #a.
	self assert: a size equals: 2.
	instance1 := (a keys at: 1).
	instance2 := (a keys at: 2).
	self assert: instance1 class identicalTo: InquisitorTestVariableDummy.
	self assert: instance2 class identicalTo: InquisitorTestVariableDummy.
	self assert: instance1 ~= instance2.
	self assert: (a at: instance1) size equals: 2.
	self assert: (a at: instance2) size equals: 1.
	invocation1 := (a at: instance1) keys at: 1.
	invocation2 := (a at: instance1) keys at: 2.
	invocation3 := (a at: instance2) keys at: 1.
	self assert: invocation1 ~= invocation3.
	self assert: invocation2 ~= invocation3.
	"No need to check invocation1 ~= invocation2 because they are keys of the same dictionary"
	self assertCollection: ((a at: instance1) at: invocation1) hasSameElements: { 0. 1. 2 }.
	self assertCollection: ((a at: instance1) at: invocation2) hasSameElements: { 0. 1. 2 }.
	self assertCollection: ((a at: instance2) at: invocation3) hasSameElements: { 0. 1. 2 }.
]
