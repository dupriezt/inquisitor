Class {
	#name : #InqProxyMethodTest,
	#superclass : #TestCase,
	#category : #'Inquisitor-Tests'
}

{ #category : #tests }
InqProxyMethodTest >> testCodeForProxyMethodTo_NoArgument_NotOnSameClass [
	| proxyMethod methodToProxy classToProxyOn |
	methodToProxy := (InqTestAssistSuperClassForProxyMethod>>#methodToProxy_NoArgument).
	classToProxyOn := InqTestAssistClassForProxyMethod.
	proxyMethod := InqProxyMethod newToProxyMethod: methodToProxy onClass: classToProxyOn.
	self assert: (proxyMethod codeForProxyMethodTo: methodToProxy) equals:
'methodToProxy_NoArgument
	Break break.
	^ super methodToProxy_NoArgument'.
]

{ #category : #tests }
InqProxyMethodTest >> testCodeForProxyMethodTo_WithArguments_NotOnSameClass [
	| proxyMethod methodToProxy classToProxyOn |
	methodToProxy := (InqTestAssistSuperClassForProxyMethod>>#methodToProxy_WithArgument:andArgument:).
	classToProxyOn := InqTestAssistClassForProxyMethod.
	proxyMethod := InqProxyMethod newToProxyMethod: methodToProxy onClass: classToProxyOn.
	self assert: (proxyMethod codeForProxyMethodTo: methodToProxy) equals:
'methodToProxy_WithArgument: arg1 andArgument: arg2
	Break break.
	^ super methodToProxy_WithArgument: arg1 andArgument: arg2'.
]
