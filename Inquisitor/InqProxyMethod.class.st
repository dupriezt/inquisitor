Class {
	#name : #InqProxyMethod,
	#superclass : #Object,
	#instVars : [
		'proxiedMethod',
		'proxyMethod',
		'targetMethod',
		'isInstalled'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqProxyMethod class >> newForTargetMethod: aCompiledMethod [
	^ self new targetMethod: aCompiledMethod; yourself
]

{ #category : #actions }
InqProxyMethod >> compileProxiedMethodFor: aCompiledMethod [
	"Compile a method containing the same code as @aCompiledMethod, but with a different name. Return the method it compiles"
	| selectorForProxiedMethod |
	selectorForProxiedMethod := ('___', aCompiledMethod selector).
	(aCompiledMethod methodClass selectors includes: (selectorForProxiedMethod asSymbol)) ifTrue: [ self error: 'Class already contains a method with the same name as the proxied method I want to compile' "It's easy to add a piece of code that crafts a selector that is available. For now, failing with an explicit error message is enough."].
	aCompiledMethod methodClass compile: ('___', aCompiledMethod ast sourceCode).
	^ aCompiledMethod methodClass >> selectorForProxiedMethod asSymbol
]

{ #category : #actions }
InqProxyMethod >> compileProxyMethodFor: aCompiledMethod calling: anotherCompiledMethod [
	"Compile a method with the same name as @aCompiledMethod, whose code does some instrumentation (like logging the call) and return the result of calling @anotherCompiledMethod.
	Return the compiled method."
	| firstLine body lastLine firstLineOfAnotherCompiledMethod instrumentation fullSourceCode |
	firstLine := (aCompiledMethod sourceCode substrings: (Character cr asString)) first.
	firstLineOfAnotherCompiledMethod := (anotherCompiledMethod sourceCode substrings: (Character cr asString)) first.
	body := '| returnValue |
	returnValue := self ', firstLineOfAnotherCompiledMethod, '.'.
	instrumentation := self instrumentationCode.
	lastLine := '^ returnValue'.
	"body := '| newInstance |
	newInstance := self ', firstLineOfAnotherCompiledMethod, '.
	(self == Tazar) ifTrue: [Tozor list add: {thisContext sender sourceNodeExecuted. newInstance}].'.
	lastLine := '	^ newInstance'."
	fullSourceCode :=
		firstLine, Character cr asString,
		Character tab asString, body, Character cr asString,
		Character tab asString, instrumentation, Character cr asString,
		Character tab asString, lastLine.
	aCompiledMethod methodClass compile: fullSourceCode.
	^ aCompiledMethod methodClass >> (aCompiledMethod selector)
]

{ #category : #actions }
InqProxyMethod >> install [
	self isInstalled ifTrue: [ ^ self "Proxy is already installed"].
	proxiedMethod := self compileProxiedMethodFor: targetMethod.
	proxyMethod := self compileProxyMethodFor: targetMethod calling: proxiedMethod.
	isInstalled := true.
	
]

{ #category : #actions }
InqProxyMethod >> instrumentationCode [
	"See #compileProxyMethodFor:calling: for the code that will be around this code. This code can use temp variable 'returnValue' to access the value returned by the proxied method"
	^ ''
]

{ #category : #accessing }
InqProxyMethod >> isInstalled [
	isInstalled ifNil: [ isInstalled := false ].
	^ isInstalled
]

{ #category : #accessing }
InqProxyMethod >> targetMethod: aCompiledMethod [
	targetMethod := aCompiledMethod
]

{ #category : #actions }
InqProxyMethod >> unInstall [
	self isInstalled ifFalse: [ ^ self "Nothing to uninstall"].
	targetMethod methodClass compile: (targetMethod ast sourceCode).
	proxiedMethod removeFromSystem.
	isInstalled := false
]
