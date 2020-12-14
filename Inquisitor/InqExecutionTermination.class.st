Class {
	#name : #InqExecutionTermination,
	#superclass : #Object,
	#instVars : [
		'description'
	],
	#category : #Inquisitor
}

{ #category : #testing }
InqExecutionTermination class >> isAbstract [
	^ self == InqExecutionTermination
]

{ #category : #testing }
InqExecutionTermination class >> newForDescription: aString [
	^ self new description: aString; yourself
]

{ #category : #accessing }
InqExecutionTermination >> description [

	^ description
]

{ #category : #accessing }
InqExecutionTermination >> description: anObject [

	description := anObject
]

{ #category : #testing }
InqExecutionTermination >> isNormalTermination [
	self subclassResponsibility
]
