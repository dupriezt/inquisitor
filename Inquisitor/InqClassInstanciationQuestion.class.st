Class {
	#name : #InqClassInstanciationQuestion,
	#superclass : #InqInquisitorQuestion,
	#instVars : [
		'class_'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqClassInstanciationQuestion class >> newForClass: aClass [
	^ self new class_: aClass; yourself
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> askToInquisitor: anInquisitor [
	"Answer the question, using anInquisitor to run the execution. No need to return anything, fill your capturePoints variable with the capture points constituting the answer to the question."
	self runExecutionWithInquisitor: anInquisitor.
]

{ #category : #accessing }
InqClassInstanciationQuestion >> class_ [
	^ class_
]

{ #category : #accessing }
InqClassInstanciationQuestion >> class_: aClass [
	class_ := aClass
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> indexesOfInstanceCreationPrimitives [
	"* 70 */ primitiveNew,
	/* 71 */ primitiveNewWithArg,
	/* 79 */ primitiveNewMethod,
	/* 148 */ primitiveClone,
	/* 160 */ primitiveAdoptInstance,"
	^#(70 71 79 148 160)
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> methodsToProxyOnClassSideOfClass: aClass [
	"Returns the list of all class side methods of @aClass that should be proxied to capture all attempts to instanciate it"
	^ aClass class allMethods select: [ :meth | self indexesOfInstanceCreationPrimitives includes: meth primitive ]
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> methodsToProxyOnInstanceSideOf: aClass [
	"Returns the list of all instance side methods of @aClass that should be proxied to capture all attempts to instanciate it"
	^ aClass allMethods select: [ :meth | self indexesOfInstanceCreationPrimitives includes: meth primitive ]
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> proxyMethod: aCompiledMethod onClass: aClass [
	"Create a proxy method on @aClass with the same name as @aCompiledMethod and pointing to it. If @aClass already has a method with that name, first copy @aCompiledMethod with a different name, then create a proxy method pointing to it."
	
	(aClass methods includes: aCompiledMethod) ifFalse: [
	"@aClass does not have a method with the name of @aCompiledMethod"
		aClass compile: (self proxyMethodSourceCodeForCompiledMethod: aCompiledMethod).
	] ifTrue: [ 
	"@aClass has a method with the same name as @aCompiledMethod"
		self error: 'Case not handled yet'
	]
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> proxyMethodSourceCodeForCompiledMethod: aCompiledMethod [
	"Method name + arguments"
	| firstLine body |
	firstLine := (aCompiledMethod sourceCode substrings: (Character cr asString)) first.
	body := 'Break break.
	^ super ', aCompiledMethod selector asString.
	^ firstLine, Character cr asString, Character tab asString, body
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> resultDescription [
	"Returns a string describing the result of this question"
	self flag: 'TODO'.
	^ 'Class Instanciation result'
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	"This method will be called whenever the inquisited execution encounters a breakpoint present in the @breakpoints variable of this object (the list of breakpoints this question has installed)"
	self flag: 'TODO'.
	self inform: 'Breakpoint hit'
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> whenBreakpointlessBreakException: aBreakException [
	self inform: 'breakpointLessException'
]
