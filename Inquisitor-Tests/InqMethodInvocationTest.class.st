"
A MethodInvocationTest is a test class for testing the behavior of MethodInvocation
"
Class {
	#name : #InqMethodInvocationTest,
	#superclass : #TestCase,
	#category : #'Inquisitor-Tests'
}

{ #category : #tests }
InqMethodInvocationTest >> createMethodInvocation [
	^ InqMethodInvocation newForContext: thisContext
	
	
]

{ #category : #tests }
InqMethodInvocationTest >> testEquality [
	"Two MethodInvocation created from the same context should be ="
	self assert: (InqMethodInvocation newForContext: thisContext) equals: (InqMethodInvocation newForContext: thisContext)
]

{ #category : #tests }
InqMethodInvocationTest >> testInequality [
	"Two MethodInvocation created from different contexts should be ~="
	self assert: (InqMethodInvocation newForContext: thisContext) ~= (self createMethodInvocation)
]
