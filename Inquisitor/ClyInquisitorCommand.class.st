Class {
	#name : #ClyInquisitorCommand,
	#superclass : #SycSourceCodeCommand,
	#category : #Inquisitor
}

{ #category : #testing }
ClyInquisitorCommand class >> canBeExecutedInContext: aToolContext [
	^ (super canBeExecutedInContext: aToolContext) and: [ InqInquisitor mainInstance isNotNil ]
]

{ #category : #activation }
ClyInquisitorCommand class >> contextMenuOrder [
	^ 100
]

{ #category : #testing }
ClyInquisitorCommand class >> isAbstract [
	^ self = ClyInquisitorCommand
]
