Class {
	#name : #InqProxyMethodForClassInstanciationTest,
	#superclass : #InqProxyMethodTest,
	#instVars : [
		'targetClass',
		'questionHash'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #tests }
InqProxyMethodForClassInstanciationTest >> createProxyMethod [
	^ InqProxyMethodForClassInstanciation newForTargetMethod: targetMethod andTargetClass: targetClass andClassInstanciationQuestionHash: questionHash
]

{ #category : #tests }
InqProxyMethodForClassInstanciationTest >> testProxyMethodWithArguments [
	| question |
	targetClass := InqTestAssistClassForProxyMethod.
	targetMethod := (targetClass>>#methodToProxy_WithArgument:andArgument:).
	question := InqClassInstanciationQuestion newForClass: targetClass.
	questionHash := question hash.
	self templateForTestProxyMethodWithArguments 
	
]

{ #category : #tests }
InqProxyMethodForClassInstanciationTest >> testProxyMethodWithNoArguments [
	| question |
	targetClass := InqTestAssistClassForProxyMethod.
	targetMethod := (targetClass>>#methodToProxy_NoArgument).
	question := InqClassInstanciationQuestion newForClass: targetClass.
	questionHash := question hash.
	self templateForTestProxyMethodWithNoArgument
	
]
