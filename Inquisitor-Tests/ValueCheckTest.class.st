Class {
	#name : #ValueCheckTest,
	#superclass : #InquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #tests }
ValueCheckTest >> assistClass [
	^ InquisitorTestValueCheckDummy
]

{ #category : #tests }
ValueCheckTest >> dummyForTestValueCheck [
	(self assistClass new) incrementArgument: 1; incrementArgument: 2.
	(self assistClass new) incrementArgument: 3
]

{ #category : #running }
ValueCheckTest >> setUp [
	super setUp.
	self assistClass clearInstances
]

{ #category : #running }
ValueCheckTest >> tearDown [
	self assistClass clearInstances.
	super tearDown
]

{ #category : #tests }
ValueCheckTest >> testValueCheck [
	| questionedMethod targetNode question cps qMeth inst2 inst1 |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestValueCheck.
	questionedMethod :=(self assistClass)>>#incrementArgument:.
	targetNode := questionedMethod ast body statements at: 1. "targetNode = 'self flag: 'targetNode'"
	question := ValueCheckQuestion newForNode: targetNode andExpression: 'anInteger isPrime'.
	question askToInquisitor: inquisitor.
	cps := question capturePoints.
	self assert: cps size equals: 3.
	"Asserts that the three capture points have been captured in different method invocations"
	self assertCollection: (cps collect: [:cp | cp methodInvocation contextHash]) matchesPattern: { #a. #b. #c }.
	self assert: self assistClass instances size equals: 2.
	inst1 := self assistClass instances first.
	inst2 := self assistClass instances second.
	qMeth := questionedMethod.
	self assertCapturePoint: (cps at: 1) value: false receiver: inst1 method: qMeth nbBreakpoints: 1.
	self assertCapturePoint: (cps at: 2) value: true receiver: inst1 method: qMeth nbBreakpoints: 2.
	self assertCapturePoint: (cps at: 3) value: true receiver: inst2 method: qMeth nbBreakpoints: 3.
]
