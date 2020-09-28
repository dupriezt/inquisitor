Class {
	#name : #VariableValueHistoryQuestion,
	#superclass : #InquisitorQuestion,
	#instVars : [
		'method',
		'objectToValueHistoryDictionary'
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
VariableValueHistoryQuestion >> additionalResultPrint [
	self objectToValueHistoryDictionary inspect
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> askToInquisitor: anInquisitor [
	| b varValueAndVarOwner varValue varOwner |
	node isVariable ifFalse: [ self inform: 'Node is not a variable'. ^ self ].
	b := self placeWriteBreakpointOnVariable.
	"methodOrClass := node isLocalVariable
		ifTrue: [ method ]
		ifFalse: [ method methodClass ].
	b := VariableBreakpoint watchVariableWrites: node name inClass: methodOrClass."
	[anInquisitor runExecution] on: Break do: [ :ex| 
		varValueAndVarOwner := self getVariableValueAndVariableOwnerInContext: ex signalerContext sender.
		varValue := varValueAndVarOwner at: #varValue.
		varOwner := varValueAndVarOwner at: #varOwner.
		self objectToValueHistoryDictionary at: varOwner ifAbsentPut: [ OrderedCollection new ].
		(self objectToValueHistoryDictionary at: varOwner) add: varValue.
		ex resume.
	].
	b remove.
	anInquisitor addResolvedQuestion: self.
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
	aStream
		nextPutAll: self variableName;
		nextPutAll: ': Variable Value History'
]

{ #category : #accessing }
VariableValueHistoryQuestion >> result [
	^ objectToValueHistoryDictionary
]

{ #category : #'as yet unclassified' }
VariableValueHistoryQuestion >> resultDescription [
	| varOwnerCount varValueChangeCount |
	varOwnerCount := 0.
	varValueChangeCount := 0.
	self objectToValueHistoryDictionary associationsDo: [ :assoc | varOwnerCount := varOwnerCount + 1. varValueChangeCount := varValueChangeCount + (assoc value size) ].
	^ varValueChangeCount asString, ' value changes, over ', varOwnerCount asString, ' objects'
]

{ #category : #accessing }
VariableValueHistoryQuestion >> variableName [
	^ node name
]
