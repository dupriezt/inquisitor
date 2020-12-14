"
I provide a mechanism to log the instances of myself that are created
"
Class {
	#name : #InqInquisitorTestAssistClass,
	#superclass : #Object,
	#classVars : [
		'instances'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #'instance creation' }
InqInquisitorTestAssistClass class >> clearInstances [
	instances := nil
]

{ #category : #'instance creation' }
InqInquisitorTestAssistClass class >> instances [
	instances ifNil: [ instances := OrderedCollection new ].
	^ instances
]

{ #category : #'instance creation' }
InqInquisitorTestAssistClass class >> new [
	| result |
	result := super new.
	self instances add: result.
	^ result
]

{ #category : #'as yet unclassified' }
InqInquisitorTestAssistClass >> callDoNothingWithError [
	"Used for tests"
	self doNothingWithError.
	self doNothingWithError.
]

{ #category : #'as yet unclassified' }
InqInquisitorTestAssistClass >> doNothing [
	"Used for tests"
	Point new
]

{ #category : #'as yet unclassified' }
InqInquisitorTestAssistClass >> doNothingWithError [
	<haltOrBreakpointForTesting>
	"Used for tests"
	Point new.
	1/0.
]

{ #category : #'as yet unclassified' }
InqInquisitorTestAssistClass >> doNothingWithHalt [
	<haltOrBreakpointForTesting>
	"Used for tests"
	Point new.
	self halt.
]
