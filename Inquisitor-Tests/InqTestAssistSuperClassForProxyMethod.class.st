Class {
	#name : #InqTestAssistSuperClassForProxyMethod,
	#superclass : #Object,
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
InqTestAssistSuperClassForProxyMethod >> methodToProxy_NoArgument [
	Point new.
	^ 'Hello'
]

{ #category : #'as yet unclassified' }
InqTestAssistSuperClassForProxyMethod >> methodToProxy_WithArgument: arg1 andArgument: arg2 [
	Point new.
	^ 'Hello'
]
