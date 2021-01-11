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
	"BE VARY CAREFUL ABOUT WRITING CODE THAT CREATE INSTANCES HERE. Because this code will be inserted in, for example, the proxy method to Behavior>>#basicNew, if it creates instances, it will call Behavior>>#basicNew again, trigger the proxy method, execute this code again...etc eternally looping and freezing the image. If this code does create instances, make sure there's a condition so that it doesn't loop"
	^ '(InqClassInstanciationQuestion hashToQuestionDictionary at: ', classInstanciationQuestionHash asString,' ) instanciationData add: 1.'.
"	^ '.'"
	"^ '(InqClassInstanciationQuestion hashToQuestionDictionary at: ', classInstanciationQuestionHash asString,' ) instanciationData add: returnValue class.'."
	
	"^ '(returnValue class == ', targetClass name asString, ') ifTrue: [(InqClassInstanciationQuestion hashToQuestionDictionary at: ', classInstanciationQuestionHash asString, ') instanciationData add: {thisContext sender sourceNoceExecuted. returnValue}].' "
]

{ #category : #accessing }
InqProxyMethodForClassInstanciation >> targetClass: aClass [
	targetClass := aClass
]
