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
	"self inform: aRBProgramNode asString.
	self inform: testClass asString.
	self inform: testMethodName asString."
	| testInstance sindarinDebugger hitCount nodes |
	testInstance := testClass new.
	sindarinDebugger := SindarinDebugger debug: [ testInstance perform: testMethodName ].
	sindarinDebugger stepUntil: [ sindarinDebugger method selector = testMethodName.].
	hitCount := 0.
	nodes := OrderedCollection new.
	[sindarinDebugger isExecutionFinished] whileFalse: [ ((sindarinDebugger node) == aRBProgramNode) ifTrue: [ hitCount := hitCount + 1 ]. nodes add: sindarinDebugger node. sindarinDebugger step ].
	self inform: hitCount asString.
	nodes inspect.
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
