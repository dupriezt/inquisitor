Class {
	#name : #InqInquisitorAdded,
	#superclass : #InqAnnouncement,
	#instVars : [
		'inquisitor'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqInquisitorAdded class >> newFor: anInquisitor [
	^ self new inquisitor: anInquisitor; yourself
]

{ #category : #accessing }
InqInquisitorAdded >> inquisitor [
	^ inquisitor
]

{ #category : #accessing }
InqInquisitorAdded >> inquisitor: anObject [

	inquisitor := anObject
]
