Class {
	#name : #InqInquisitorTestValueCheckDummy,
	#superclass : #InqInquisitorTestAssistClass,
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
InqInquisitorTestValueCheckDummy >> incrementArgument: anInteger [
	self flag: 'targetNode'.
	^ anInteger + 1
]
