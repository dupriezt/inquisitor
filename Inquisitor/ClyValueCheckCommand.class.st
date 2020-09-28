Class {
	#name : #ClyValueCheckCommand,
	#superclass : #ClyInquisitorCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyValueCheckCommand class >> contextMenuOrder [
	^95
]

{ #category : #accessing }
ClyValueCheckCommand >> defaultMenuIconName [
	^#comments
]

{ #category : #accessing }
ClyValueCheckCommand >> defaultMenuItemName [
	^'Value Check'
]

{ #category : #accessing }
ClyValueCheckCommand >> execute [
	| dict |
	dict := Dictionary new.
	dict at: #node put: sourceNode.
	(ValueCheckPopup on: dict) openWithSpec
]
