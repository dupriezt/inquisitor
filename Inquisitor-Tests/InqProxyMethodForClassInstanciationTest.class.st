Class {
	#name : #InqProxyMethodForClassInstanciationTest,
	#superclass : #InqProxyMethodTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #tests }
InqProxyMethodForClassInstanciationTest >> shadowCompileProxiedMethodFor: aCompiledMethod usingProxyObject: anInqProxyMethod [
	OpalCompiler new compilationContextClass 
]

{ #category : #tests }
InqProxyMethodForClassInstanciationTest >> testSourceCodeOfProxiedMethodFor [
	| targetClass targetMethod q proxy |
	targetClass := InqTestAssistClassForProxyMethod.
	targetMethod := InqTestAssistSuperClassForProxyMethod>>#methodToProxy_NoArgument.
	q := InqClassInstanciationQuestion newForClass: targetClass.
	proxy := InqProxyMethodForClassInstanciation newForTargetMethod: targetMethod andTargetClass: targetClass andClassInstanciationQuestionHash: (q hash).
	
	self assert: (proxy sourceCodeOfProxiedMethodFor: targetMethod) equals: 
'___methodToProxy_NoArgument
	Point new.
	^ ''Hello'''
]

{ #category : #tests }
InqProxyMethodForClassInstanciationTest >> testSourceCodeOfProxyMethodForCalling [
	| targetClass targetMethod q proxy dummyProxiedMethod |
	targetClass := InqTestAssistClassForProxyMethod.
	targetMethod := InqTestAssistSuperClassForProxyMethod>>#methodToProxy_NoArgument.
	q := InqClassInstanciationQuestion newForClass: targetClass.
	proxy := InqProxyMethodForClassInstanciation newForTargetMethod: targetMethod andTargetClass: targetClass andClassInstanciationQuestionHash: (q hash).
	
	dummyProxiedMethod := InqDummyCompiledMethod new sourceCode: 
'___methodToProxy_NoArgument
	Point new.
	^ ''Hello'''.
	
	self assert: (proxy sourceCodeOfProxyMethodFor: targetMethod calling: dummyProxiedMethod) equals: 
'methodToProxy_NoArgument
	| returnValue |
	returnValue := self ___methodToProxy_NoArgument.
	(returnValue class == InqTestAssistClassForProxyMethod) ifTrue: [(InqClassInstanciationQuestion hashToQuestionDictionary at: ', q hash asString, ') instanciationData add: {thisContext sender sourceNoceExecuted. returnValue}].
	^ returnValue'
]
