"
A MethodInvocationTest is a test class for testing the behavior of MethodInvocation
"
Class {
	#name : #MethodInvocationTest,
	#superclass : #TestCase,
	#category : #'Inquisitor-Tests'
}

{ #category : #tests }
MethodInvocationTest >> createMethodInvocation [
	^ MethodInvocation newForContext: thisContext
	
	
]

{ #category : #tests }
MethodInvocationTest >> testEquality [
	"Two MethodInvocation created from the same context should be ="
	self assert: (MethodInvocation newForContext: thisContext) equals: (MethodInvocation newForContext: thisContext)
]

{ #category : #tests }
MethodInvocationTest >> testInequality [
	"Two MethodInvocation created from different contexts should be ~="
	self assert: (MethodInvocation newForContext: thisContext) ~= (self createMethodInvocation)
]
