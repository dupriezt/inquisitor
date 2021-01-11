Class {
	#name : #InqProxyMethod,
	#superclass : #Object,
	#instVars : [
		'proxiedMethod',
		'proxyMethod',
		'targetMethod',
		'isInstalled',
		'isProxiedMethodInstalled',
		'isProxyMethodInstalled'
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
	| selectorOfProxiedMethod |
	selectorOfProxiedMethod := aCompiledMethod methodClass compile: (self sourceCodeOfProxiedMethodFor: aCompiledMethod).
	^ aCompiledMethod methodClass >> selectorOfProxiedMethod
]

{ #category : #actions }
InqProxyMethod >> compileProxyMethodFor: aCompiledMethod calling: anotherCompiledMethod [
	"Compile a method with the same name as @aCompiledMethod, whose code does some instrumentation (like logging the call) and return the result of calling @anotherCompiledMethod.
	Return the compiled method."
	aCompiledMethod methodClass compile: (self sourceCodeOfProxyMethodFor: aCompiledMethod calling: anotherCompiledMethod).
	^ aCompiledMethod methodClass >> (aCompiledMethod selector)
]

{ #category : #actions }
InqProxyMethod >> install [
	self isInstalled ifTrue: [ ^ self "Proxy is already installed"].
	proxiedMethod := self compileProxiedMethodFor: targetMethod.
	isProxiedMethodInstalled := true.
	proxyMethod := self compileProxyMethodFor: targetMethod calling: proxiedMethod.
	isProxyMethodInstalled := true.
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

{ #category : #actions }
InqProxyMethod >> isProxiedMethodInstalled [
	^ isProxiedMethodInstalled
]

{ #category : #actions }
InqProxyMethod >> sourceCodeOfProxiedMethodFor: aCompiledMethod [
	"Return the source code compiled by #compiledProxiedMethodFor:"
	| selectorForProxiedMethod |
	selectorForProxiedMethod := ('___', aCompiledMethod selector).
	(aCompiledMethod methodClass selectors includes: (selectorForProxiedMethod asSymbol)) ifTrue: [ self error: 'Class already contains a method with the same name as the proxied method I want to compile' "It's easy to add a piece of code that crafts a selector that is available. For now, failing with an explicit error message is enough."].
	^ ('___', aCompiledMethod ast sourceCode).
]

{ #category : #actions }
InqProxyMethod >> sourceCodeOfProxyMethodFor: aCompiledMethod calling: anotherCompiledMethod [
	"Give the source code that #compileProxyMethodFor:calling: will compile"
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
	^ fullSourceCode
]

{ #category : #accessing }
InqProxyMethod >> targetMethod: aCompiledMethod [
	targetMethod := aCompiledMethod
]

{ #category : #actions }
InqProxyMethod >> unInstall [
	self isInstalled ifFalse: [ ^ self "Nothing to uninstall"].
	targetMethod methodClass compile: (targetMethod ast sourceCode).
	isProxyMethodInstalled := false.
	proxiedMethod removeFromSystem.
	isProxiedMethodInstalled := false.
	isInstalled := false
]
