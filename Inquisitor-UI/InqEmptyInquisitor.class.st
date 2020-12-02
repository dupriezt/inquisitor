Class {
	#name : #InqEmptyInquisitor,
	#superclass : #InqInquisitor,
	#category : #'Inquisitor-UI'
}

{ #category : #printing }
InqEmptyInquisitor >> printOn: aStream [

	aStream nextPutAll: 'No Inquisitor'
]
