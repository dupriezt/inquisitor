Class {
	#name : #MethodReturnQuestion,
	#superclass : #InquisitorQuestion,
	#instVars : [
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
	^ capturePoints
]

{ #category : #'as yet unclassified' }
MethodReturnQuestion >> resultDescription [
	self flag: 'todo'.
	^ 'Result description of MethodReturnQuestion Todo'
"	^ 'The execution encountered this node ', hitCount asString, ' times'"
]

{ #category : #'as yet unclassified' }
MethodReturnQuestion >> returnValueOfNode: aReturnNode inContext: aContext [
	| returnValueNode |
	aReturnNode isReturn ifFalse: [ self error: 'aReturnNode is not a RBReturnNode' ].
	returnValueNode := aReturnNode children at: 1.
	"Return statement is ^ self. So return value is the receiver of the context"
	returnValueNode isSelfVariable ifTrue: [ ^ aContext receiver ].
	"Return statement is ^ nil, ^ true or ^ false. So return value is that literal"
	(returnValueNode isLiteralNode and: [ {nil. true. false} includes: (returnValueNode value) ]) ifTrue: [ ^ returnValueNode value ].
	"Else, the return statement has been compiled into a returnTop bytecode. So return value is the top of the context's internal stack"
	^ aContext top .
]

{ #category : #'as yet unclassified' }
MethodReturnQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [

	| returnValue cp |
	self breakpointsEncountered add: aBreakpoint.
	returnValue := self returnValueOfNode: aBreakpoint node inContext: aBreakException signalerContext sender.
	cp := self capturePointFactory newCapturePointForContext: (aBreakException signalerContext sender)  andCapturedValue: returnValue andBreakpointsEncountered: self breakpointsEncountered copy.
	self capturePoints add: cp.
]
