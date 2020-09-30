Class {
	#name : #ValueCheckQuestion,
	#superclass : #InquisitorQuestion,
	#instVars : [
		'expression',
		'valueHistory'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
ValueCheckQuestion class >> newForNode: aRBProgramNode andExpression: aString [
	^ self new node: aRBProgramNode; expression: aString; yourself
]

{ #category : #'as yet unclassified' }
ValueCheckQuestion >> additionalResultPrint [
	self valueHistory inspect
]

{ #category : #'as yet unclassified' }
ValueCheckQuestion >> askToInquisitor: anInquisitor [
	| b compiler |
	b := Breakpoint new node: node.
	b always.
	b install.
	[anInquisitor runExecution] on: Break do: [ :ex| 
		compiler := OpalCompiler new context: ex signalerContext sender; source: expression.
		self valueHistory add: compiler evaluate.
		ex resume.
	].
	b remove.
	anInquisitor addResolvedQuestion: self.
]

{ #category : #'as yet unclassified' }
ValueCheckQuestion >> expression: aString [
	expression := aString
]

{ #category : #converting }
ValueCheckQuestion >> printOn: aStream [
	aStream
		nextPutAll: 'Registered ';
		nextPutAll: valueHistory size asString;
		nextPutAll: ' values for expression "';
		nextPutAll: expression;
		nextPutAll: '" on node ';
		nextPutAll: node asString
]

{ #category : #'as yet unclassified' }
ValueCheckQuestion >> result [
	^ valueHistory
]

{ #category : #'as yet unclassified' }
ValueCheckQuestion >> resultDescription [
	| vh |
	vh := self valueHistory.
	^ '', (vh size asString), ' values: ', (vh at: 1 ifAbsent: [ '' ]) asString, ' ', (vh at: 2 ifAbsent: [ '' ]) asString, ' ', (vh at: 3 ifAbsent: [ '' ]) asString, ' ', ((vh size > 3) ifTrue: [ '...' ] ifFalse: [ '' ])
]

{ #category : #'as yet unclassified' }
ValueCheckQuestion >> valueHistory [
	valueHistory ifNil: [ valueHistory := OrderedCollection new ].
	^ valueHistory
]
