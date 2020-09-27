Class {
	#name : #ClyHitCheckCommand,
	#superclass : #ClyDebuggingCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyHitCheckCommand class >> contextMenuOrder [
	^100
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
	Inquisitor askQuestion: (HitCheckQuestion newForNode: sourceNode).
]
