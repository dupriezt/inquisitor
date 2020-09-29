Class {
	#name : #ClyInquisitorCommand,
	#superclass : #SycSourceCodeCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyInquisitorCommand class >> contextMenuOrder [
	^ 100
]

{ #category : #testing }
ClyInquisitorCommand class >> isAbstract [
	^ self = ClyInquisitorCommand
]
