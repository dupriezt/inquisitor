Class {
	#name : #InqFactorialDummy,
	#superclass : #Object,
	#category : #'Inquisitor-SideStuff'
}

{ #category : #'as yet unclassified' }
InqFactorialDummy >> computeFactorialOf: anInt [
	anInt = 0 ifTrue: [ ^ 1 ].
	^ anInt * (self computeFactorialOf: (anInt - 1))
]
