Class {
	#name : #MethodReturnQuestion,
	#superclass : #InquisitorQuestion,
	#instVars : [
		'returnValueData',
		'method'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
MethodReturnQuestion class >> newForMethod: aCompiledMethod [
	^ self new method: aCompiledMethod; yourself
]

{ #category : #'as yet unclassified' }
MethodReturnQuestion >> askToInquisitor: anInquisitor [
	| returnNodes |
	method ast lastIsReturn ifTrue: [ "add breakpoint to handle implicit return statement" ].
	returnNodes := (method ast allChildren select: [:astNode | astNode isReturn]).
	"Install breakpoints on all return nodes and store them"
	self breakpoints addAll: (returnNodes collect: [ :retNode | Breakpoint new node: retNode; always; install; yourself ]).
	self runExecutionWithInquisitor: anInquisitor.
	anInquisitor addResolvedQuestion: self.
]

{ #category : #accessing }
MethodReturnQuestion >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #converting }
MethodReturnQuestion >> printOn: aStream [
	self flag: 'todo'.
	aStream nextPutAll: 'todo'.
	"aStream
		nextPutAll: hitCount asString;
		nextPutAll: ' hits on node ';
		nextPutAll: node asString"
]

{ #category : #'as yet unclassified' }
MethodReturnQuestion >> result [
	^ returnValueData
]

{ #category : #'as yet unclassified' }
MethodReturnQuestion >> resultDescription [
	self flag: 'todo'.
	^ 'Todo'
"	^ 'The execution encountered this node ', hitCount asString, ' times'"
]

{ #category : #accessing }
MethodReturnQuestion >> returnValueData [
	returnValueData ifNil: [ returnValueData := Dictionary new ].
	^ returnValueData
]

{ #category : #'as yet unclassified' }
MethodReturnQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [

	| returnValue |
	(aBreakpoint node isReturn and: [ 
		 (aBreakpoint node children at: 1) isSelfVariable not ]) ifTrue: [ "node is explicit return and not ^ self, so it has been compiled as returnTop bytecode, i.e. the return value is at the top of the stack" 
		returnValue := aBreakException signalerContext sender top ].
	self returnValueData at: #test put: returnValue
]
