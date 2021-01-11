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

	targetNode isTempVariable ifTrue: [ 
		^ InqLocalVariableValueHistoryQuestion
			  newForNode: targetNode
			  andMethod: targetMethod ].
	targetNode isArgumentVariable ifTrue: [ 
		^ InqArgumentVariableValueHistoryQuestion
			  newForNode: targetNode
			  andMethod: targetMethod ].
	targetNode isInstanceVariable ifTrue: [ 
		^ InqInstanceVariableValueHistoryQuestion
			  newForNode: targetNode
			  andMethod: targetMethod ].
	targetNode isClassVariable ifTrue: [ 
		^ InqClassVariableValueHistoryQuestion
			  newForNode: targetNode
			  andMethod: targetMethod ].
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
