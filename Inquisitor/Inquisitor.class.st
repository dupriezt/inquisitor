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
Inquisitor class >> askQuestion: anInquisitorQuestion [
	self mainInstance ifNil: [ self error: 'Undefined main instance of Inquisitor' ] ifNotNil: [ :mnInst | mnInst askQuestion: anInquisitorQuestion ]
]

{ #category : #'as yet unclassified' }
Inquisitor class >> mainInstance [
	^ mainInstance
]

{ #category : #'as yet unclassified' }
Inquisitor class >> mainInstance: anInstance [
	mainInstance := anInstance
]

{ #category : #adding }
Inquisitor >> addResolvedQuestion: anInquisitorQuestion [
	self inform: anInquisitorQuestion resultDescription
]

{ #category : #'as yet unclassified' }
Inquisitor >> askQuestion: anInquisitorQuestion [
	anInquisitorQuestion askToInquisitor: self
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
Inquisitor >> runExecution [
	| testInstance |
	testInstance := testClass new.
	testInstance setUp.
	testInstance perform: testMethodName
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
