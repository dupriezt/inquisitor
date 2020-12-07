Class {
	#name : #InqInquisitorMainInstanceChanged,
	#superclass : #InqAnnouncement,
	#instVars : [
		'newMainInquisitor',
		'oldMainInquisitor'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqInquisitorMainInstanceChanged class >> newForOldMainInstance: anInquisitor andNewMainInstance: anotherInquisitor [
	^ self new oldMainInquisitor: anInquisitor; newMainInquisitor: anotherInquisitor; yourself
]

{ #category : #accessing }
InqInquisitorMainInstanceChanged >> newMainInquisitor [

	^ newMainInquisitor
]

{ #category : #accessing }
InqInquisitorMainInstanceChanged >> newMainInquisitor: anObject [

	newMainInquisitor := anObject
]

{ #category : #accessing }
InqInquisitorMainInstanceChanged >> oldMainInquisitor [

	^ oldMainInquisitor
]

{ #category : #accessing }
InqInquisitorMainInstanceChanged >> oldMainInquisitor: anObject [

	oldMainInquisitor := anObject
]
