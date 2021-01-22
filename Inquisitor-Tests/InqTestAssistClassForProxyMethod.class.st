Class {
	#name : #InqTestAssistClassForProxyMethod,
	#superclass : #InqTestAssistSuperClassForProxyMethod,
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
InqTestAssistClassForProxyMethod >> methodToProxy_NoArgument [
	Point new.
	^ 42
]

{ #category : #'as yet unclassified' }
InqTestAssistClassForProxyMethod >> methodToProxy_WithArgument: arg1 andArgument: arg2 [
	Point new.
	^ 42
]
