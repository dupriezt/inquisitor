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
	self flag: 'todo'
	
]
