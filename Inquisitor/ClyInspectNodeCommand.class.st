Class {
	#name : #ClyInspectNodeCommand,
	#superclass : #ClyInquisitorSourceCodeCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyInspectNodeCommand class >> contextMenuOrder [
	^95
]

{ #category : #accessing }
ClyInspectNodeCommand >> defaultMenuIconName [
	^#comments
]

{ #category : #accessing }
ClyInspectNodeCommand >> defaultMenuItemName [
	^'Inspect node'
]

{ #category : #accessing }
ClyInspectNodeCommand >> execute [
	sourceNode inspect
]
