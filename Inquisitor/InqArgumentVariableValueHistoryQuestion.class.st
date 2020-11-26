Class {
	#name : #InqArgumentVariableValueHistoryQuestion,
	#superclass : #InqVariableValueHistoryQuestion,
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
InqArgumentVariableValueHistoryQuestion >> getVariableValueAndVariableOwnerInContext: aContext [
	"Must return a dictionary of the form: #varValue -> value of the watched variable, #varOwner -> object or class owning the variable"
	| result |
	result := Dictionary new.
	result at: #varOwner put: aContext receiver.
	result at: #varValue put: (aContext tempNamed: node name).
	^ result
]

{ #category : #'as yet unclassified' }
InqArgumentVariableValueHistoryQuestion >> placeWriteBreakpointOnVariable [
	"Must return the breakpoint it placed"
	"Argument variables are never written to, so placing the breakpoint on the method declaring the argument instead"
	| b |
	b := Breakpoint new node: method ast.
	b always.
	b install.
	^ b
]
