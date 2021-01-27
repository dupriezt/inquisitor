Class {
	#name : #InqTimeStampedStackTest,
	#superclass : #TestCase,
	#category : #'Inquisitor-Tests'
}

{ #category : #accessing }
InqTimeStampedStackTest >> method1 [
	self method2
]

{ #category : #accessing }
InqTimeStampedStackTest >> method2 [
	self method3
]

{ #category : #accessing }
InqTimeStampedStackTest >> method3 [ 
	self method4.
	self method5
]

{ #category : #accessing }
InqTimeStampedStackTest >> method4 [
	Point new.
	^ 42
]

{ #category : #accessing }
InqTimeStampedStackTest >> method5 [
	Point x:5 y:2.
	^ 31
]

{ #category : #tests }
InqTimeStampedStackTest >> testDifferentSize [
	"This test may not be necessary. It turns out that in the second execution that goes one call further (method4), the pc of the method3 call is higher so the test actually tests the same thing as testSameMethodNameDifferentPC"
	| proc1 tStampedStack1 proc2 tStampedStack2 |
	proc1 := [ self method1 ] newProcess.
	[ proc1 suspendedContext method selector = #method3 ] whileFalse: [ proc1 step ].
	tStampedStack1 := InqTimeStampedStack newForContext: (proc1 suspendedContext).
	"method1(35)>method2(35)>method3(41)"
	
	proc2 := [ self method1 ] newProcess.
	[ proc2 suspendedContext method selector = #method4 ] whileFalse: [ proc2 step ].
	tStampedStack2 := InqTimeStampedStack newForContext: (proc2 suspendedContext).
	"method1(35)>method2(35)>method3(43)>method4(41)"
	
	self assert: (tStampedStack1 comesBefore: tStampedStack2).
	self assert: (tStampedStack2 comesBefore: tStampedStack1) not.
]

{ #category : #tests }
InqTimeStampedStackTest >> testSameMethodNameDifferentPC [
	| proc1 tStampedStack1 proc2 tStampedStack2 |
	proc1 := [ self method1 ] newProcess.
	[ proc1 suspendedContext method selector = #method4 ] whileFalse: [ proc1 step ].
	tStampedStack1 := InqTimeStampedStack newForContext: (proc1 suspendedContext).
	"method1(35)>method2(35)>method3(43)>method4(41)"
	
	proc2 := [ self method1 ] newProcess.
	[ proc2 suspendedContext method selector = #method5 ] whileFalse: [ proc2 step ].
	tStampedStack2 := InqTimeStampedStack newForContext: (proc2 suspendedContext).
	"method1(35)>method2(35)>method3(46)>method5(65)"
	
	self assert: (tStampedStack1 comesBefore: tStampedStack2).
	self assert: (tStampedStack2 comesBefore: tStampedStack1) not.
]

{ #category : #tests }
InqTimeStampedStackTest >> testSameStackDifferentExecutions [
	| proc1 tStampedStack1 proc2 tStampedStack2 |
	proc1 := [ self method1 ] newProcess.
	[ proc1 suspendedContext method selector = #method3 ] whileFalse: [ proc1 step ].
	tStampedStack1 := InqTimeStampedStack newForContext: (proc1 suspendedContext).
	"method1(35)>method2(35)>method3(41)"
	
	proc2 := [ self method1 ] newProcess.
	[ proc2 suspendedContext method selector = #method3 ] whileFalse: [ proc2 step ].
	tStampedStack2 := InqTimeStampedStack newForContext: (proc2 suspendedContext).
	"method1(35)>method2(35)>method3(41)"
	
	self assert: (tStampedStack1 comesBefore: tStampedStack2).
	self assert: (tStampedStack2 comesBefore: tStampedStack1).
]

{ #category : #tests }
InqTimeStampedStackTest >> testSameStackSameExecution [
	| proc1 tStampedStack1 tStampedStack2 |
	proc1 := [ self method1 ] newProcess.
	[ proc1 suspendedContext method selector = #method3 ] whileFalse: [ proc1 step ].
	tStampedStack1 := InqTimeStampedStack newForContext: (proc1 suspendedContext).
	"method1(35)>method2(35)>method3(41)"
	
	tStampedStack2 := InqTimeStampedStack newForContext: (proc1 suspendedContext).
	"method1(35)>method2(35)>method3(41)"
	
	self assert: (tStampedStack1 comesBefore: tStampedStack2).
	self assert: (tStampedStack2 comesBefore: tStampedStack1).
]
