Class {
	#name : #InqInquisitorUpdated,
	#superclass : #InqAnnouncement,
	#instVars : [
		'inquisitor'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqInquisitorUpdated class >> newFor: anInquisitor [
	^ self new inquisitor: anInquisitor; yourself
]

{ #category : #accessing }
InqInquisitorUpdated >> inquisitor [

	^ inquisitor
]

{ #category : #accessing }
InqInquisitorUpdated >> inquisitor: anObject [

	inquisitor := anObject
]
