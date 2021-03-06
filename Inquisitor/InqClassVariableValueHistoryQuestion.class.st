Class {
	#name : #InqClassVariableValueHistoryQuestion,
	#superclass : #InqVariableValueHistoryQuestion,
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
InqClassVariableValueHistoryQuestion >> getVariableValueAndVariableOwnerInContext: aContext [
	"Must return a dictionary of the form: #varValue -> value of the watched variable, #varOwner -> object or class owning the variable"
	| result |
	result := Dictionary new.
	result at: #varOwner put: aContext receiver class.
	result at: #varValue put: (aContext receiver classVarNamed: node name).
	^ result
]

{ #category : #'as yet unclassified' }
InqClassVariableValueHistoryQuestion >> name [
	^ 'ClassVariableHistory'
]

{ #category : #'as yet unclassified' }
InqClassVariableValueHistoryQuestion >> placeWriteBreakpointOnVariable [
	"Must return the breakpoint it placed"
	^ VariableBreakpoint watchVariableWrites: node name inClass: method methodClass soleInstance
]
