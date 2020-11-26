Class {
	#name : #InqVariableValueHistoryQuestion,
	#superclass : #InqInquisitorQuestion,
	#instVars : [
		'method'
	],
	#category : #Inquisitor
}

{ #category : #testing }
InqVariableValueHistoryQuestion class >> isAbstract [
	^ self = InqVariableValueHistoryQuestion
]

{ #category : #'instance creation' }
InqVariableValueHistoryQuestion class >> newForNode: aRBProgramNode andMethod: aCompiledMethod [
	^ self new node: aRBProgramNode; method: aCompiledMethod; yourself
]

{ #category : #'as yet unclassified' }
InqVariableValueHistoryQuestion >> askToInquisitor: anInquisitor [
	| b |
	node isVariable ifFalse: [ self error: 'Node is not a variable' ].
	b := self placeWriteBreakpointOnVariable.
	self breakpoints add: b.
	self runExecutionWithInquisitor: anInquisitor.
]

{ #category : #'as yet unclassified' }
InqVariableValueHistoryQuestion >> getVariableValueAndVariableOwnerInContext: aContext [
	"Must return a dictionary of the form: #varValue -> value of the watched variable, #varOwner -> object or class owning the variable"
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
InqVariableValueHistoryQuestion >> getVariableValueInContext: aContext [
	| varIsLocal varValue |
	varIsLocal := node isLocalVariable.
	varValue := varIsLocal
		ifTrue: [ aContext tempNamed: node name ]
		ifFalse: [ aContext receiver var ]
]

{ #category : #accessing }
InqVariableValueHistoryQuestion >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #'as yet unclassified' }
InqVariableValueHistoryQuestion >> placeWriteBreakpointOnVariable [
	"Must return the breakpoint it placed"
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
InqVariableValueHistoryQuestion >> resultDescription [
	"Only shows the first 5 returned values"
	| returnValueString threeDots numberOfValuesShown |
	numberOfValuesShown := 5.
	returnValueString := ',' join: ((self keepFirst: numberOfValuesShown ofCollection: self capturePoints) collect: [ :cp | cp capturedValue asString ]).
	threeDots := self capturePoints size > numberOfValuesShown ifTrue: [ '...' ] ifFalse: [ '' ].
	^ self capturePoints size asString, ' values: ', returnValueString, threeDots, ' for var ', self variableName , ' in ', self fullMethodNameOfNode.
]

{ #category : #accessing }
InqVariableValueHistoryQuestion >> variableName [
	^ node name
]

{ #category : #'as yet unclassified' }
InqVariableValueHistoryQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
		| varValueAndVarOwner varValue cp |
	self breakpointsEncountered add: aBreakpoint.
	varValueAndVarOwner := self getVariableValueAndVariableOwnerInContext: aBreakException signalerContext sender.
		varValue := varValueAndVarOwner at: #varValue.
		"varOwner := varValueAndVarOwner at: #varOwner."
		cp := self capturePointFactory newCapturePointForContext: (aBreakException signalerContext sender) andCapturedValue: varValue andBreakpointsEncountered: self breakpointsEncountered copy.
		self capturePoints add: cp.
]
