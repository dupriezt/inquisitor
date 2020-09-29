Class {
	#name : #ClyVariableValueHistoryCommand,
	#superclass : #ClyInquisitorSourceCodeCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyVariableValueHistoryCommand class >> canBeExecutedInContext: aSourceCodeContext [
	^ true
	"^ (super canBeExecutedInContext: aSourceCodeContext)
		and: [ aSourceCodeContext selectedSourceNode isVariable ]"
]

{ #category : #activation }
ClyVariableValueHistoryCommand class >> contextMenuOrder [
	^95
]

{ #category : #accessing }
ClyVariableValueHistoryCommand >> createQuestion [
	sourceNode isTemp ifTrue: [ ^ LocalVariableValueHistoryQuestion newForNode: sourceNode andMethod: method].
	sourceNode isArgumentVariable ifTrue: [ ^ ArgumentVariableValueHistoryQuestion newForNode: sourceNode andMethod: method ].
	self error: 'Unsupported variable type'
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
	Inquisitor askQuestion: self createQuestion
]
