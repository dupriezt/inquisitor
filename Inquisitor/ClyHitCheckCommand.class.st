Class {
	#name : #ClyHitCheckCommand,
	#superclass : #ClyDebuggingCommand,
	#category : #Inquisitor
}

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
	Inquisitor mainInstance hitCheckOn: sourceNode
]
