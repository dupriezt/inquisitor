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
ValueCheckQuestion >> askToInquisitor: anInquisitor [
	| b |
	b := Breakpoint new node: node; always; install; yourself.
	self breakpoints add: b.
	self runExecutionWithInquisitor: anInquisitor.
]

{ #category : #'as yet unclassified' }
ValueCheckQuestion >> expression: aString [
	expression := aString
]

{ #category : #converting }
ValueCheckQuestion >> printOn: aStream [
	self flag: 'todo'.
	aStream nextPutAll: 'Value Check printOn TODO'.

"	aStream
		nextPutAll: 'Registered ';
		nextPutAll: valueHistory size asString;
		nextPutAll: ' values for expression ""';
		nextPutAll: expression;
		nextPutAll: '"" on node ';
		nextPutAll: node asString"
]

{ #category : #'as yet unclassified' }
ValueCheckQuestion >> result [
	^ valueHistory
]

{ #category : #'as yet unclassified' }
ValueCheckQuestion >> resultDescription [
	| vh |
	self flag: 'todo'.
	^ 'ValueCheck resultDescription TODO'.
"	vh := self valueHistory.
	^ '', (vh size asString), ' values: ', (vh at: 1 ifAbsent: [ '' ]) asString, ' ', (vh at: 2 ifAbsent: [ '' ]) asString, ' ', (vh at: 3 ifAbsent: [ '' ]) asString, ' ', ((vh size > 3) ifTrue: [ '...' ] ifFalse: [ '' ])"
]

{ #category : #'as yet unclassified' }
ValueCheckQuestion >> valueHistory [
	valueHistory ifNil: [ valueHistory := OrderedCollection new ].
	^ valueHistory
]

{ #category : #'as yet unclassified' }
ValueCheckQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	| compiler expressionValue cp |
	self breakpointsEncountered add: aBreakpoint.
	
	compiler := OpalCompiler new context: aBreakException signalerContext sender; receiver: aBreakException signalerContext sender receiver; source: expression.
	expressionValue := compiler evaluate.
	cp := self capturePointFactory newCapturePointForContext: (aBreakException signalerContext sender) andCapturedValue: expressionValue andBreakpointsEncountered: self breakpointsEncountered copy.
	self capturePoints add: cp.
]
