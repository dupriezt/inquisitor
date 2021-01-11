Class {
	#name : #ClyHitCheckCommand,
	#superclass : #ClyInquisitorSourceCodeCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyHitCheckCommand class >> contextMenuOrder [
	^90
]

{ #category : #accessing }
ClyHitCheckCommand >> defaultMenuIconName [
	^#comments
]

{ #category : #accessing }
ClyHitCheckCommand >> defaultMenuItemName [
	^'Hit Check'
]

{ #category : #accessing }
ClyHitCheckCommand >> execute [
	InqInquisitor askQuestion: (InqHitCheckQuestion newForNode: targetNode).
]
