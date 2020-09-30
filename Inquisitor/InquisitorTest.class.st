Class {
	#name : #InquisitorTest,
	#superclass : #InquisitorTestAncestor,
	#instVars : [
		'myInstanceVariable'
	],
	#classVars : [
		'myClassVariable'
	],
	#category : #Inquisitor
}

{ #category : #tests }
InquisitorTest >> doSomething [
	myInstanceVariable := 43
]

{ #category : #tests }
InquisitorTest >> fillVariables [
	myInstanceVariable := 42
]

{ #category : #tests }
InquisitorTest >> methodWithArgument: aString andArgument: aNumber [

	| s |
	Point x: aNumber y: aNumber + 2.
	s := aString, 'hello'.
	^ s
	
]

{ #category : #tests }
InquisitorTest >> setInstanceVariableTo43 [
	myInstanceVariable := 43
]

{ #category : #tests }
InquisitorTest >> testDummy [
	| i |
	i := 0.
	1+1.
	myInstanceVariable := Point x: 4 y:2.
	myClassVariable := Point x: 6 y: 0.
	[ i = 3 ] whileFalse: [ i := i + 1. myInstanceVariable := Point x: 4 y: i. myClassVariable := Point x: 6 y: 2*i ].
	self inform: 'testDummy was ran'.
	self assert: true.
]

{ #category : #tests }
InquisitorTest >> testDummy2 [
	| i |
	i := 0.
	1+1.
	Point new.
	[ i = 3 ] whileFalse: [ i := i + 1 ].
	self inform: 'testDummy2 was ran'.
	self assert: true.
]

{ #category : #tests }
InquisitorTest >> testDummy3 [
	| i |
	i := 5.
	Point new.
	[ i = 0 ] whileFalse: [ i := i - 1 ].
	self assert: i equals: 1.
]

{ #category : #tests }
InquisitorTest >> testDummy4 [
	self doSomething.
	self fillVaraibles.
	self doSomething.
	self assert: myInstanceVariable equals: 42
]

{ #category : #tests }
InquisitorTest >> testDummyCallingMethodWithArguments [
	self methodWithArgument: 'anneau' andArgument: 52.
	self methodWithArgument: 'bateau' andArgument: 64.
	self inform: 'testDummyCallingMethodWithArguments was ran'.
	self assert: true.
]
