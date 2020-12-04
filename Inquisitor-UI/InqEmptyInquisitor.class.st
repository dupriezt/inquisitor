Class {
	#name : #InqEmptyInquisitor,
	#superclass : #InqInquisitor,
	#category : #'Inquisitor-UI'
}

{ #category : #printing }
InqEmptyInquisitor >> asStringForClyCommand [
	^ 'No Inquisitor exist'
]

{ #category : #initialization }
InqEmptyInquisitor >> initialize [
	self executionCode: 'No execution code'.
	self setupCode: 'No setup code'.
]

{ #category : #testing }
InqEmptyInquisitor >> isEmptyInquisitor [
	^ true
]

{ #category : #printing }
InqEmptyInquisitor >> printOn: aStream [

	aStream nextPutAll: 'No Inquisitor'
]
