Class {
	#name : #InquisitorTestVariableDummy,
	#superclass : #InquisitorTestAssistClass,
	#instVars : [
		'myInstanceVariable'
	],
	#classVars : [
		'myClassVariable'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #initialization }
InquisitorTestVariableDummy class >> setClassVariableTo: aValue [
	myClassVariable := aValue
]

{ #category : #initialization }
InquisitorTestVariableDummy >> methodWithArgument: arg1 [
	Point new.
	^ self 
]

{ #category : #initialization }
InquisitorTestVariableDummy >> setInstanceVariableTo: aValue [
	myInstanceVariable := aValue
]

{ #category : #initialization }
InquisitorTestVariableDummy >> setLocalVariables [
	| a b |
	a := 0.
	Point new.
	a := 1.
	b := 42.
	a := 2.
]
