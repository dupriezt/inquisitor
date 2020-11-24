Class {
	#name : #VariableValueHistoryQuestion,
	#superclass : #InquisitorQuestion,
	#instVars : [
		'method',
		'objectToValueHistoryDictionary',
		'data'
	],
	#category : #Inquisitor
}

{ #category : #testing }
VariableValueHistoryQuestion class >> isAbstract [
	^ self = VariableValueHistoryQuestion
]

{ #category : #'instance creation' }
VariableValueHistoryQuestion class >> newForNode: aRBProgramNode andMethod: aCompiledMethod [
	^ self new node: aRBProgramNode; method: aCompiledMethod; yourself
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> askToInquisitor: anInquisitor [
	| b |
	node isVariable ifFalse: [ self error: 'Node is not a variable' ].
	b := self placeWriteBreakpointOnVariable.
	self breakpoints add: b.
	self runExecutionWithInquisitor: anInquisitor.
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> data [
	"Dictionary<1:Object, Dictionary<2:MethodInvocation, 3:OrderedCollection<value>>
	Stores the values a variable has during the execution.
	1: owner of the variable (instance of the class where the variable is defined)
	2: a method invocation during which the value of the variable is changed
	3: the list of values the variable takes during the method invocation used as key
	"
	data ifNil: [ data := Dictionary new ].
	^ data
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> getVariableValueAndVariableOwnerInContext: aContext [
	"Must return a dictionary of the form: #varValue -> value of the watched variable, #varOwner -> object or class owning the variable"
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> getVariableValueInContext: aContext [
	| varIsLocal varValue |
	varIsLocal := node isLocalVariable.
	varValue := varIsLocal
		ifTrue: [ aContext tempNamed: node name ]
		ifFalse: [ aContext receiver var ]
]

{ #category : #accessing }
VariableValueHistoryQuestion >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> objectToValueHistoryDictionary [
	objectToValueHistoryDictionary ifNil: [ objectToValueHistoryDictionary := Dictionary new ].
	^ objectToValueHistoryDictionary
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> placeWriteBreakpointOnVariable [
	"Must return the breakpoint it placed"
	self subclassResponsibility 
]

{ #category : #converting }
VariableValueHistoryQuestion >> printOn: aStream [
	self flag: 'todo'.
	aStream nextPutAll: 'Todo'.
"	aStream
		nextPutAll: self variableName;
		nextPutAll: ': Variable Value History'"
]

{ #category : #accessing }
VariableValueHistoryQuestion >> result [
	^ self data
	"^ objectToValueHistoryDictionary"
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> resultDescription [
	| varOwnerCount varValueChangeCount |
	self flag: 'todo'.
	^ 'Result description of VariableValueHistory Todo'
	"varOwnerCount := 0.
	varValueChangeCount := 0.
	self data associationsDo: [ :assoc | varOwnerCount := varOwnerCount + 1. varValueChangeCount := varValueChangeCount + (assoc value size) ].
	^ varValueChangeCount asString, ' value changes, over ', varOwnerCount asString, ' objects'"
]

{ #category : #accessing }
VariableValueHistoryQuestion >> variableName [
	^ node name
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
		| varValueAndVarOwner varValue cp |
	self breakpointsEncountered add: aBreakpoint.
	varValueAndVarOwner := self getVariableValueAndVariableOwnerInContext: aBreakException signalerContext sender.
		varValue := varValueAndVarOwner at: #varValue.
		"varOwner := varValueAndVarOwner at: #varOwner."
		cp := self capturePointFactory newCapturePointForContext: (aBreakException signalerContext sender) andCapturedValue: varValue andBreakpointsEncountered: self breakpointsEncountered copy.
		self capturePoints add: cp.
]
