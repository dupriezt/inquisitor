Class {
	#name : #InqInquisitorRemoved,
	#superclass : #InqAnnouncement,
	#instVars : [
		'inquisitor'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqInquisitorRemoved class >> newFor: anInquisitor [
	^ self new inquisitor: anInquisitor; yourself
]

{ #category : #accessing }
InqInquisitorRemoved >> inquisitor [

	^ inquisitor
]

{ #category : #accessing }
InqInquisitorRemoved >> inquisitor: anObject [

	inquisitor := anObject
]
