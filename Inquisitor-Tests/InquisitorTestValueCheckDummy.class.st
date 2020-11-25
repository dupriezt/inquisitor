Class {
	#name : #InquisitorTestValueCheckDummy,
	#superclass : #InquisitorTestAssistClass,
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
InquisitorTestValueCheckDummy >> incrementArgument: anInteger [
	self flag: 'targetNode'.
	^ anInteger + 1
]
