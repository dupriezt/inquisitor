Class {
	#name : #InqProxyMethodForClassInstanciation,
	#superclass : #InqProxyMethod,
	#instVars : [
		'classInstanciationQuestionHash',
		'targetClass'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqProxyMethodForClassInstanciation class >> newForTargetMethod: aCompiledMethod andTargetClass: aClass andClassInstanciationQuestionHash: anInteger [
	"@aCompiledMethod is assumed to be a method creating instances of @aClass. Return an instance of me, which can install a proxy method to intercept all calls to @aCompiledMethod and transmit information about that call and instance of @aClass it created to the classInstanciationQuestion of hash @anInteger"
	^ self new targetMethod: aCompiledMethod; targetClass: aClass; classInstanciationQuestionHash: anInteger; yourself
]

{ #category : #accessing }
InqProxyMethodForClassInstanciation >> classInstanciationQuestionHash: anInteger [
	classInstanciationQuestionHash := anInteger
]

{ #category : #accessing }
InqProxyMethodForClassInstanciation >> instrumentationCode [
	"See #compileProxyMethodFor:calling: for the code that will be around this code. This code can use temp variable 'returnValue' to access the value returned by the proxied method"
	^ '(returnValue class == ', targetClass name asString, ') ifTrue: [(InqClassInstanciationQuestion hashToQuestionDictionary at: ', classInstanciationQuestionHash asString, ') instanciationData add: {thisContext sender sourceNoceExecuted. returnValue}].' 
]

{ #category : #accessing }
InqProxyMethodForClassInstanciation >> targetClass: aClass [
	targetClass := aClass
]
