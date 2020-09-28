Class {
	#name : #ClyVariableValueHistoryCommand,
	#superclass : #ClyInquisitorCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyVariableValueHistoryCommand class >> contextMenuOrder [
	^95
]

{ #category : #accessing }
ClyVariableValueHistoryCommand >> defaultMenuIconName [
	^#comments
]

{ #category : #accessing }
ClyVariableValueHistoryCommand >> defaultMenuItemName [
	^'Value History of Variable'
]

{ #category : #accessing }
ClyVariableValueHistoryCommand >> execute [

	Inquisitor askQuestion: (VariableValueHistoryQuestion newForNode: sourceNode andMethod: method)
]
