Class {
	#name : #InqValueCheckQuestion,
	#superclass : #InqInquisitorQuestion,
	#instVars : [
		'expression'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqValueCheckQuestion class >> newForNode: aRBProgramNode andExpression: aString [
	^ self new node: aRBProgramNode; expression: aString; yourself
]

{ #category : #'as yet unclassified' }
InqValueCheckQuestion >> askToInquisitor: anInquisitor [
	| b |
	b := Breakpoint new node: node; always; install; yourself.
	self breakpoints add: b.
	self runExecutionWithInquisitor: anInquisitor.
]

{ #category : #'as yet unclassified' }
InqValueCheckQuestion >> expression: aString [
	expression := aString
]

{ #category : #'as yet unclassified' }
InqValueCheckQuestion >> resultDescription [
	"Only shows the first 5 values"
	| numberOfValuesShown valuesString threeDots |
	numberOfValuesShown := 5.
	valuesString := ',' join: ((self keepFirst: numberOfValuesShown ofCollection: self capturePoints) collect: [ :cp | cp capturedValue asString ]).
	threeDots := self capturePoints size > numberOfValuesShown ifTrue: [ '...' ] ifFalse: [ '' ].
	^ self capturePoints size asString, ' values: ', valuesString, threeDots, ' of ', expression, ' in ', self fullMethodNameOfNode 
	
	
]

{ #category : #'as yet unclassified' }
InqValueCheckQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	| compiler expressionValue cp |
	self breakpointsEncountered add: aBreakpoint.
	
	compiler := OpalCompiler new context: aBreakException signalerContext sender; receiver: aBreakException signalerContext sender receiver; source: expression.
	expressionValue := compiler evaluate.
	cp := self capturePointFactory newCapturePointForContext: (aBreakException signalerContext sender) andCapturedValue: expressionValue andBreakpointsEncountered: self breakpointsEncountered copy.
	self capturePoints add: cp.
]
