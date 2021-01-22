Class {
	#name : #InqProxyMethodTest,
	#superclass : #TestCase,
	#instVars : [
		'targetMethod'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
InqProxyMethodTest >> createProxyMethod [
	^ InqProxyMethod newForTargetMethod: targetMethod
]

{ #category : #tests }
InqProxyMethodTest >> templateForTestProxyMethodWithArguments [	
	| proxyMethod originalCodeOfTargetMethod |
	proxyMethod := self createProxyMethod.
	originalCodeOfTargetMethod := targetMethod sourceCode.

	[
	proxyMethod install.
	self assert: proxyMethod proxyMethod selector equals: targetMethod selector.
	self assert: proxyMethod proxiedMethod selector equals: #___, targetMethod selector.
	
	self assert: proxyMethod proxyMethod sourceCode equals: 'methodToProxy_WithArgument: arg1 andArgument: arg2
	| returnValue |
	returnValue := self ___methodToProxy_WithArgument: arg1 andArgument: arg2.
	', proxyMethod instrumentationCode, '
	^ returnValue'.
	self assert: proxyMethod proxiedMethod sourceCode equals: '___', originalCodeOfTargetMethod.
	] ensure: [ 
		proxyMethod unInstall.
		self assert: (InqTestAssistClassForProxyMethod>>#methodToProxy_WithArgument:andArgument:) sourceCode equals: originalCodeOfTargetMethod.
		self should: [(InqTestAssistClassForProxyMethod>>#___methodToProxy_WithArgument:andArgument:)] raise: KeyNotFound.
	]
]

{ #category : #tests }
InqProxyMethodTest >> templateForTestProxyMethodWithNoArgument [
	| proxyMethod originalCodeOfTargetMethod |
	proxyMethod := self createProxyMethod.
	originalCodeOfTargetMethod := targetMethod sourceCode.

	[
	proxyMethod install.
	self assert: proxyMethod proxyMethod selector equals: targetMethod selector.
	self assert: proxyMethod proxiedMethod selector equals: #___, targetMethod selector.
	
	self assert: proxyMethod proxyMethod sourceCode equals: 'methodToProxy_NoArgument
	| returnValue |
	returnValue := self ___methodToProxy_NoArgument.
	', proxyMethod instrumentationCode, '
	^ returnValue'.
	self assert: proxyMethod proxiedMethod sourceCode equals: '___', originalCodeOfTargetMethod.
	] ensure: [ 
		proxyMethod unInstall.
		self assert: (InqTestAssistClassForProxyMethod>>#methodToProxy_NoArgument) sourceCode equals: originalCodeOfTargetMethod.
		self should: [(InqTestAssistClassForProxyMethod>>#___methodToProxy_NoArgument)] raise: KeyNotFound.
	]
]

{ #category : #tests }
InqProxyMethodTest >> testProxyMethodWithArguments [	
	targetMethod := (InqTestAssistClassForProxyMethod>>#methodToProxy_WithArgument:andArgument:).
	self templateForTestProxyMethodWithArguments
]

{ #category : #tests }
InqProxyMethodTest >> testProxyMethodWithNoArgument [
	targetMethod := (InqTestAssistClassForProxyMethod>>#methodToProxy_NoArgument).
	self templateForTestProxyMethodWithNoArgument
]
