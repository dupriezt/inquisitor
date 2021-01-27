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
	self method4
]

{ #category : #accessing }
InqTimeStampedStackTest >> method4 [
	Point new.
	^ 42
]

{ #category : #tests }
InqTimeStampedStackTest >> testEqualStacks [
	| proc tStampedStack |
	proc := [ self method1 ] newProcess.
	[ proc suspendedContext method selector = #method4 ] whileFalse: [ proc step ].
	tStampedStack := InqTimeStampedStack newForContext: (proc suspendedContext).
	tStampedStack inspect.
"	proc suspendedContext stack inspect."
	"FREEZES ..."
]

{ #category : #tests }
InqTimeStampedStackTest >> testTest [
	self halt.
]
