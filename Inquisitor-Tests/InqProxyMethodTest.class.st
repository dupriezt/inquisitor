Class {
	#name : #InqProxyMethodTest,
	#superclass : #TestCase,
	#category : #'Inquisitor-Tests'
}

{ #category : #tests }
InqProxyMethodTest >> testProxyMethodWithArguments [	
	| proxyMethod targetMethod originalCodeOfTargetMethod |
	targetMethod := (InqTestAssistClassForProxyMethod>>#methodToProxy_WithArgument:andArgument:).
	proxyMethod := InqProxyMethod newForTargetMethod: targetMethod.
	originalCodeOfTargetMethod := targetMethod sourceCode.

	[
	proxyMethod install.
	self assert: proxyMethod proxyMethod selector equals: targetMethod selector.
	self assert: proxyMethod proxiedMethod selector equals: #___, targetMethod selector.
	
	self assert: proxyMethod proxyMethod sourceCode equals: 'methodToProxy_WithArgument: arg1 andArgument: arg2
	| returnValue |
	returnValue := self ___methodToProxy_WithArgument: arg1 andArgument: arg2.
	"instrumentation code"
	^ returnValue'.
	self assert: proxyMethod proxiedMethod sourceCode equals: '___', originalCodeOfTargetMethod.
	] ensure: [ 
		proxyMethod unInstall.
		self assert: (InqTestAssistClassForProxyMethod>>#methodToProxy_WithArgument:andArgument:) sourceCode equals: originalCodeOfTargetMethod.
		self should: [(InqTestAssistClassForProxyMethod>>#___methodToProxy_WithArgument:andArgument:)] raise: KeyNotFound.
	]
]

{ #category : #tests }
InqProxyMethodTest >> testProxyMethodWithNoArgument [
	| proxyMethod targetMethod originalCodeOfTargetMethod |
	targetMethod := (InqTestAssistClassForProxyMethod>>#methodToProxy_NoArgument).
	proxyMethod := InqProxyMethod newForTargetMethod: targetMethod.
	originalCodeOfTargetMethod := targetMethod sourceCode.

	[
	proxyMethod install.
	self assert: proxyMethod proxyMethod selector equals: targetMethod selector.
	self assert: proxyMethod proxiedMethod selector equals: #___, targetMethod selector.
	
	self assert: proxyMethod proxyMethod sourceCode equals: 'methodToProxy_NoArgument
	| returnValue |
	returnValue := self ___methodToProxy_NoArgument.
	"instrumentation code"
	^ returnValue'.
	self assert: proxyMethod proxiedMethod sourceCode equals: '___', originalCodeOfTargetMethod.
	] ensure: [ 
		proxyMethod unInstall.
		self assert: (InqTestAssistClassForProxyMethod>>#methodToProxy_NoArgument) sourceCode equals: originalCodeOfTargetMethod.
		self should: [(InqTestAssistClassForProxyMethod>>#___methodToProxy_NoArgument)] raise: KeyNotFound.
	]
]
