Class {
	#name : #ClyMethodReturnCommand,
	#superclass : #ClyInquisitorSourceCodeAndMethodCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyMethodReturnCommand class >> contextMenuOrder [
	^95
]

{ #category : #accessing }
ClyMethodReturnCommand >> defaultMenuIconName [
	^#comments
]

{ #category : #accessing }
ClyMethodReturnCommand >> defaultMenuItemName [
	^'Return Values of Method'
]

{ #category : #accessing }
ClyMethodReturnCommand >> execute [
	InqInquisitor askQuestion: (InqMethodReturnQuestion newForMethod: targetMethod)
]
