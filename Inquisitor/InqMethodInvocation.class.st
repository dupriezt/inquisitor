"
Inherits from OrderedCollection to have the behaviour that two MethodInvocation are = if their contextHash and invokedMethod are the same.
contextHash is stored as the first element of this collection.
invokedMethod is stored as the second one
"
Class {
	#name : #InqMethodInvocation,
	#superclass : #OrderedCollection,
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqMethodInvocation class >> newForContext: aContext [
	^ self new add: aContext hash; add: aContext method; yourself
]

{ #category : #accessing }
InqMethodInvocation >> contextHash [
	^ self at: 1
]

{ #category : #accessing }
InqMethodInvocation >> invokedMethod [
	^ self at: 2
]
