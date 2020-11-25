"
I provide a mechanism to log the instances of myself that are created
"
Class {
	#name : #InquisitorTestAssistClass,
	#superclass : #Object,
	#classVars : [
		'instances'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #'instance creation' }
InquisitorTestAssistClass class >> clearInstances [
	instances := nil
]

{ #category : #'instance creation' }
InquisitorTestAssistClass class >> instances [
	instances ifNil: [ instances := OrderedCollection new ].
	^ instances
]

{ #category : #'instance creation' }
InquisitorTestAssistClass class >> new [
	| result |
	result := super new.
	self instances add: result.
	^ result
]
