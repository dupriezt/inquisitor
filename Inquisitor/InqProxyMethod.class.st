Class {
	#name : #InqProxyMethod,
	#superclass : #Object,
	#instVars : [
		'proxiedMethod',
		'targetedClass',
		'proxyMethod'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqProxyMethod class >> newToProxyMethod: aCompiledMethod onClass: aClass [
	(aClass methods includes: aCompiledMethod) ifFalse: [
		"@aClass does not have a method with the name of @aCompiledMethod"
		^ self new proxiedMethod: aCompiledMethod; targetedClass: aClass
	] ifTrue: [ 
		"@aClass has a method with the same name as @aCompiledMethod"
		self error: 'Case not handled yet'
	].
	
]

{ #category : #actions }
InqProxyMethod >> codeForProxyMethodTo: aCompiledMethod [
	| firstLine body |
	"Method name + arguments"
	firstLine := (aCompiledMethod sourceCode substrings: (Character cr asString)) first.
	body := 'InqProxyMethodExecution signal.
	^ super ', firstLine.
	^ firstLine, Character cr asString, Character tab asString, body
]

{ #category : #actions }
InqProxyMethod >> install [
	targetedClass compile: (self codeForProxyMethodTo: proxiedMethod).
	proxyMethod := targetedClass>>(proxiedMethod selector)
]

{ #category : #accessing }
InqProxyMethod >> proxiedMethod: aCompiledMethod [
	proxiedMethod := aCompiledMethod
]

{ #category : #accessing }
InqProxyMethod >> targetedClass: aClass [
	targetedClass := aClass
]

{ #category : #actions }
InqProxyMethod >> unInstall [
	proxyMethod removeFromSystem
]
