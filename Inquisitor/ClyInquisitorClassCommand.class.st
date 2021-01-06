Class {
	#name : #ClyInquisitorClassCommand,
	#superclass : #ClyInquisitorCommand,
	#instVars : [
		'targetClass'
	],
	#category : #Inquisitor
}

{ #category : #testing }
ClyInquisitorClassCommand class >> contextMenuOrder [
	^ 200
]

{ #category : #testing }
ClyInquisitorClassCommand class >> isAbstract [
	^ self = ClyInquisitorClassCommand 
]

{ #category : #execution }
ClyInquisitorClassCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	
	targetClass := aToolContext lastSelectedClass.
]

{ #category : #accessing }
ClyInquisitorClassCommand >> targetClass [

	^ targetClass
]

{ #category : #accessing }
ClyInquisitorClassCommand >> targetClass: anObject [

	targetClass := anObject
]
