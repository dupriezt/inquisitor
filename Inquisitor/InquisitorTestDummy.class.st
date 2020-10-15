Class {
	#name : #InquisitorTestDummy,
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
InquisitorTestDummy >> aaaa [
	Point x:4y:2.
	^ 2
]

{ #category : #tests }
InquisitorTestDummy >> aaaab [
	Point x:4y:2.
	^ self
]

{ #category : #tests }
InquisitorTestDummy >> doSomething [
	myInstanceVariable := 43
]

{ #category : #tests }
InquisitorTestDummy >> fillVariables [
	myInstanceVariable := 42
]

{ #category : #tests }
InquisitorTestDummy >> methodTakesArgument: anInt [
	^ 1 + anInt
]

{ #category : #tests }
InquisitorTestDummy >> methodWithArgument: aString andArgument: aNumber [

	| s |
	Point x: aNumber y: aNumber + 2.
	s := aString, 'hello'.
	^ s
	
]

{ #category : #tests }
InquisitorTestDummy >> setInstanceVariableTo43 [
	myInstanceVariable := 43
]

{ #category : #tests }
InquisitorTestDummy >> testDummy [
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
InquisitorTestDummy >> testDummy2 [
	| i |
	i := 0.
	1+1.
	Point new.
	[ i = 3 ] whileFalse: [ i := i + 1 ].
	self inform: 'testDummy2 was ran'.
	self assert: true.
]

{ #category : #tests }
InquisitorTestDummy >> testDummy3 [
	| i b |
	i := 5.
	b := Point new.
	[ i = 0 ] whileFalse: [ i := i - 1 ].
	self assert: i equals: 1.
]

{ #category : #tests }
InquisitorTestDummy >> testDummy4 [
	self doSomething.
	self fillVaraibles.
	self doSomething.
	self assert: myInstanceVariable equals: 42
]

{ #category : #tests }
InquisitorTestDummy >> testDummy5 [
	self methodTakesArgument: 52.
	self methodTakesArgument: 65.
	self assert: myInstanceVariable equals: 42
]

{ #category : #tests }
InquisitorTestDummy >> testDummyCallingMethodWithArguments [
	self methodWithArgument: 'anneau' andArgument: 52.
	self methodWithArgument: 'bateau' andArgument: 64.
	self inform: 'testDummyCallingMethodWithArguments was ran'.
	self assert: true.
]

{ #category : #tests }
InquisitorTestDummy >> testDummyReturnSelfStatement [
	Point x:2y:3.
	self inform: 'test dummy was executed'.
	^ self
]

{ #category : #tests }
InquisitorTestDummy >> testDummyReturnStatement [
	Point x:2y:3.
	self inform: 'test dummy was executed'.
	^ 42
]
