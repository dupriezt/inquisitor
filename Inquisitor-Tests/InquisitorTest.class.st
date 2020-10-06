Class {
	#name : #InquisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'inquisitor',
		'dummyMethod'
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
InquisitorTest >> setUp [
	super setUp.
	inquisitor := Inquisitor new.
	inquisitor isSilent: true
]

{ #category : #running }
InquisitorTest >> setUpForDummyMethod: aCompiledMethod [
	dummyMethod := aCompiledMethod.
	inquisitor testClass: dummyMethod methodClass.
	inquisitor testMethodName: dummyMethod selector.
]

{ #category : #running }
InquisitorTest >> testHitCheck [
	| oneHitNode fourHitNode q1 q2 |
	self setUpForDummyMethod: InquisitorTest>>#dummyForTestHitCheck.
	
	oneHitNode := dummyMethod ast body statements at: 1.
	q1 := HitCheckQuestion newForNode: oneHitNode.
	q1 askToInquisitor: inquisitor.
	self assert: (inquisitor questionHistory last at: #a) equals: 1.
	
	fourHitNode :=  ((dummyMethod ast body statements at: 2) arguments at: 1) body statements at: 1.
	q2 := HitCheckQuestion newForNode: fourHitNode.
	q2 askToInquisitor: inquisitor.
	self assert: (inquisitor questionHistory last at: #a) equals: 4.
]
