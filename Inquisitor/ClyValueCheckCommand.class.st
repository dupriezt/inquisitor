Class {
	#name : #ClyValueCheckCommand,
	#superclass : #ClyInquisitorSourceCodeCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyValueCheckCommand class >> contextMenuOrder [
	^100
]

{ #category : #accessing }
ClyValueCheckCommand >> defaultMenuIconName [
	^#comments
]

{ #category : #accessing }
ClyValueCheckCommand >> defaultMenuItemName [
	^'Value Check of Expression...'
]

{ #category : #accessing }
ClyValueCheckCommand >> execute [
	| dict |
	dict := Dictionary new.
	dict at: #node put: sourceNode.
	(InqValueCheckPopup on: dict) openWithSpec
]
