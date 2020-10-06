"
Inherits from OrderedCollection to have the behaviour that two MethodInvocation are = if their contextHash and invokedMethod are the same.
contextHash is stored as the first element of this collection.
invokedMethod is stored as the second one
"
Class {
	#name : #MethodInvocation,
	#superclass : #OrderedCollection,
	#category : #Inquisitor
}

{ #category : #'instance creation' }
MethodInvocation class >> newForContext: aContext [
	^ self new add: aContext hash; add: aContext method; yourself
]

{ #category : #accessing }
MethodInvocation >> contextHash [
	^ self at: 1
]

{ #category : #accessing }
MethodInvocation >> invokedMethod [
	^ self at: 2
]
