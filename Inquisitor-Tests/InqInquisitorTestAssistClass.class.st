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
