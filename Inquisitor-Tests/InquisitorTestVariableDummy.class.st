Class {
	#name : #InquisitorTestVariableDummy,
	#superclass : #Object,
	#instVars : [
		'myInstanceVariable'
	],
	#classVars : [
		'instances'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
InquisitorTestVariableDummy class >> clearInstances [
	instances := nil
]

{ #category : #'as yet unclassified' }
InquisitorTestVariableDummy class >> instances [
	instances ifNil: [ instances := OrderedCollection new ].
	^ instances
]

{ #category : #'as yet unclassified' }
InquisitorTestVariableDummy class >> new [
	| result |
	result := super new.
	self instances add: result.
	^ result
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
