Class {
	#name : #InquisitorTestVariableDummy,
	#superclass : #Object,
	#category : #'Inquisitor-Tests'
}

{ #category : #initialization }
InquisitorTestVariableDummy >> setLocalVariables [
	| a b |
	a := 0.
	Point new.
	a := 1.
	b := 42.
	a := 2.
]
