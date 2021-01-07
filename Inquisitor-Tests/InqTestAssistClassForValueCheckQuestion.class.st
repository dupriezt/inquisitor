Class {
	#name : #InqTestAssistClassForValueCheckQuestion,
	#superclass : #InqInquisitorTestAssistClass,
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
InqTestAssistClassForValueCheckQuestion >> incrementArgument: anInteger [
	self flag: 'targetNode'.
	^ anInteger + 1
]
