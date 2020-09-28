Class {
	#name : #VariableValueHistoryQuestion,
	#superclass : #InquisitorQuestion,
	#instVars : [
		'objectToValueHistory',
		'method'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
VariableValueHistoryQuestion class >> newForNode: aRBProgramNode andMethod: aCompiledMethod [
	^ self new node: aRBProgramNode; method: aCompiledMethod; yourself
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> askToInquisitor: anInquisitor [
	| b methodOrClass |
	node isVariable
		ifFalse: [ self inform: 'Node is not a variable'. ^ self ].
	methodOrClass := node isLocalVariable
		ifTrue: [ method ]
		ifFalse: [ method methodClass ].
	b := VariableBreakpoint watchVariableWrites: node name inClass: methodOrClass.
	[anInquisitor runExecution] on: Break do: [ :ex| 
		self inform: 'hey'.
		"objectOwningVariable := ex signalerContext sender receiver.
		self objectToValueHistory at"
		"compiler := OpalCompiler new context: ex signalerContext sender; source: expression.
		self valueHistory add: compiler evaluate."
		ex resume.
	].
	b remove.
	anInquisitor addResolvedQuestion: self.
]

{ #category : #accessing }
VariableValueHistoryQuestion >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> objectToValueHistory [
	objectToValueHistory ifNil: [ objectToValueHistory := Dictionary new ].
	^ objectToValueHistory
]

{ #category : #converting }
VariableValueHistoryQuestion >> printOn: aStream [
	aStream
		nextPutAll: self variableName;
		nextPutAll: ': Variable Value History'
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> resultDescription [
	^ 'resultDescription'
]

{ #category : #accessing }
VariableValueHistoryQuestion >> variableName [
	^ node name
]
