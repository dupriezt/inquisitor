Class {
	#name : #InqTestAssistClassForVariableHistoryQuestion,
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
InqTestAssistClassForVariableHistoryQuestion class >> setClassVariableTo: aValue [
	myClassVariable := aValue
]

{ #category : #initialization }
InqTestAssistClassForVariableHistoryQuestion >> methodWithArgument: arg1 [
	Point new.
	^ self 
]

{ #category : #initialization }
InqTestAssistClassForVariableHistoryQuestion >> setInstanceVariableTo: aValue [
	myInstanceVariable := aValue
]

{ #category : #initialization }
InqTestAssistClassForVariableHistoryQuestion >> setLocalVariables [
	| a b |
	a := 0.
	Point new.
	a := 1.
	b := 42.
	a := 2.
]
