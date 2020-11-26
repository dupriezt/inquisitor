Class {
	#name : #InqInquisitorTestVariableDummy,
	#superclass : #InqInquisitorTestAssistClass,
	#instVars : [
		'myInstanceVariable'
	],
	#classVars : [
		'myClassVariable'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #initialization }
InqInquisitorTestVariableDummy class >> setClassVariableTo: aValue [
	myClassVariable := aValue
]

{ #category : #initialization }
InqInquisitorTestVariableDummy >> methodWithArgument: arg1 [
	Point new.
	^ self 
]

{ #category : #initialization }
InqInquisitorTestVariableDummy >> setInstanceVariableTo: aValue [
	myInstanceVariable := aValue
]

{ #category : #initialization }
InqInquisitorTestVariableDummy >> setLocalVariables [
	| a b |
	a := 0.
	Point new.
	a := 1.
	b := 42.
	a := 2.
]
