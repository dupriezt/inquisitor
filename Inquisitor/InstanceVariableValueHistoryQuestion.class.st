Class {
	#name : #InstanceVariableValueHistoryQuestion,
	#superclass : #VariableValueHistoryQuestion,
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
InstanceVariableValueHistoryQuestion >> getVariableValueAndVariableOwnerInContext: aContext [
	"Must return a dictionary of the form: #varValue -> value of the watched variable, #varOwner -> object or class owning the variable"
	| result |
	result := Dictionary new.
	result at: #varOwner put: aContext receiver.
	result at: #varValue put: (aContext receiver instVarNamed: node name).
	^ result
]

{ #category : #'as yet unclassified' }
InstanceVariableValueHistoryQuestion >> placeWriteBreakpointOnVariable [
	"Must return the breakpoint it placed"
	^ VariableBreakpoint watchVariableWrites: node name inClass: method
]
