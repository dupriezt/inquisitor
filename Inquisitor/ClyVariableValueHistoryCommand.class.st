Class {
	#name : #ClyVariableValueHistoryCommand,
	#superclass : #ClyInquisitorSourceCodeCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyVariableValueHistoryCommand class >> canBeExecutedInContext: aSourceCodeContext [
	^ (super canBeExecutedInContext: aSourceCodeContext)
		and: [ aSourceCodeContext selectedSourceNode isVariable ]
]

{ #category : #activation }
ClyVariableValueHistoryCommand class >> contextMenuOrder [
	^95
]

{ #category : #accessing }
ClyVariableValueHistoryCommand >> createQuestion [

	sourceNode isTempVariable ifTrue: [ 
		^ InqLocalVariableValueHistoryQuestion
			  newForNode: sourceNode
			  andMethod: method ].
	sourceNode isArgumentVariable ifTrue: [ 
		^ InqArgumentVariableValueHistoryQuestion
			  newForNode: sourceNode
			  andMethod: method ].
	sourceNode isInstanceVariable ifTrue: [ 
		^ InqInstanceVariableValueHistoryQuestion
			  newForNode: sourceNode
			  andMethod: method ].
	sourceNode isClassVariable ifTrue: [ 
		^ InqClassVariableValueHistoryQuestion
			  newForNode: sourceNode
			  andMethod: method ].
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
	InqInquisitor askQuestion: self createQuestion
]
