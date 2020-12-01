Class {
	#name : #InqInquisitorTestDummy,
	#superclass : #InqInquisitorTestAncestor,
	#instVars : [
		'myInstanceVariable'
	],
	#classVars : [
		'myClassVariable'
	],
	#category : #'Inquisitor-SideStuff'
}

{ #category : #tests }
InqInquisitorTestDummy >> aaaa [
	Point x:4y:2.
	^ 2
]

{ #category : #tests }
InqInquisitorTestDummy >> aaaab [
	Point x:4y:2.
	^ self
]

{ #category : #tests }
InqInquisitorTestDummy >> doSomething [
	myInstanceVariable := 43
]

{ #category : #tests }
InqInquisitorTestDummy >> fillVariables [
	myInstanceVariable := 42
]

{ #category : #tests }
InqInquisitorTestDummy >> methodTakesArgument: anInt [
	^ 1 + anInt
]

{ #category : #tests }
InqInquisitorTestDummy >> methodWithArgument: aString andArgument: aNumber [

	| s |
	Point x: aNumber y: aNumber + 2.
	s := aString, 'hello'.
	^ s
	
]

{ #category : #tests }
InqInquisitorTestDummy >> setInstanceVariableTo43 [
	myInstanceVariable := 43
]

{ #category : #'as yet unclassified' }
InqInquisitorTestDummy >> testDummy [
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
InqInquisitorTestDummy >> testDummy2 [
	| i |
	i := 0.
	1+1.
	Point new.
	[ i = 3 ] whileFalse: [ i := i + 1 ].
	self inform: 'testDummy2 was ran'.
	self assert: true.
]

{ #category : #tests }
InqInquisitorTestDummy >> testDummy3 [
	| i b |
	i := 5.
	b := Point new.
	[ i = 0 ] whileFalse: [ i := i - 1 ].
	self assert: i equals: 1.
]

{ #category : #tests }
InqInquisitorTestDummy >> testDummy4 [
	self doSomething.
	self fillVaraibles.
	self doSomething.
	self assert: myInstanceVariable equals: 42
]

{ #category : #tests }
InqInquisitorTestDummy >> testDummy5 [
	self methodTakesArgument: 52.
	self methodTakesArgument: 65.
	self assert: myInstanceVariable equals: 42
]

{ #category : #tests }
InqInquisitorTestDummy >> testDummyCallingMethodWithArguments [
	self methodWithArgument: 'anneau' andArgument: 52.
	self methodWithArgument: 'bateau' andArgument: 64.
	self inform: 'testDummyCallingMethodWithArguments was ran'.
	self assert: true.
]

{ #category : #'as yet unclassified' }
InqInquisitorTestDummy >> testDummyFull [

	| i |
	i := 4.
	[ i = 0 ] whileFalse: [ i := i - 1. self flag: 'hitCheckTargetNode' ].
	self assert: true.
]

{ #category : #tests }
InqInquisitorTestDummy >> testDummyReturnFalseStatement [
	Point x:2y:3.
	self inform: 'test dummy was executed'.
	^ false
]

{ #category : #tests }
InqInquisitorTestDummy >> testDummyReturnImplicitSelfStatement [
	Point x:2y:3.
	self inform: 'test dummy was executed'.
]

{ #category : #tests }
InqInquisitorTestDummy >> testDummyReturnNilStatement [
	Point x:2y:3.
	self inform: 'test dummy was executed'.
	^ nil
]

{ #category : #tests }
InqInquisitorTestDummy >> testDummyReturnSelfStatement [
	Point x:2y:3.
	self inform: 'test dummy was executed'.
	^ self
]

{ #category : #tests }
InqInquisitorTestDummy >> testDummyReturnStackTopFromBlockStatement [
	Point x:2y:3.
	[ ^ 5 ] value
]

{ #category : #tests }
InqInquisitorTestDummy >> testDummyReturnTopStatement [
	Point x:2y:3.
	self inform: 'test dummy was executed'.
	^ 42
]

{ #category : #tests }
InqInquisitorTestDummy >> testDummyReturnTrueStatement [
	Point x:2y:3.
	self inform: 'test dummy was executed'.
	^ true
]
