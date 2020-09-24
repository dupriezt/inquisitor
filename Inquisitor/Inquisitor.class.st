Class {
	#name : #Inquisitor,
	#superclass : #Object,
	#instVars : [
		'testMethodName',
		'testClass'
	],
	#classVars : [
		'mainInstance'
	],
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
Inquisitor class >> mainInstance [
	^ mainInstance
]

{ #category : #'as yet unclassified' }
Inquisitor class >> mainInstance: anInstance [
	mainInstance := anInstance
]

{ #category : #'as yet unclassified' }
Inquisitor >> hitCheckOn: aRBProgramNode [
	| testInstance hitCount b |
	testInstance := testClass new.
	hitCount := 0.
	testInstance setUp.
	b := Breakpoint new node: aRBProgramNode.
	b always.
	b install.
	[testInstance perform: testMethodName] on: Break do: [ :ex| hitCount := hitCount + 1. ex resume. ].
	b remove.
	self inform: 'This node is encountered ', hitCount asString, ' times'.
]

{ #category : #'as yet unclassified' }
Inquisitor >> testClass [
	^ testClass
]

{ #category : #'as yet unclassified' }
Inquisitor >> testClass: anObject [
	testClass := anObject
]

{ #category : #'as yet unclassified' }
Inquisitor >> testMethodName [
	^ testMethodName
]

{ #category : #'as yet unclassified' }
Inquisitor >> testMethodName: anObject [
	testMethodName := anObject
]
