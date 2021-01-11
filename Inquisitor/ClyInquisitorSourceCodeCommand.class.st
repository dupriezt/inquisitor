Class {
	#name : #ClyInquisitorSourceCodeCommand,
	#superclass : #ClyInquisitorCommand,
	#instVars : [
		'targetMethod',
		'targetNode'
	],
	#classInstVars : [
		'aToolContext',
		'targetNode'
	],
	#category : #Inquisitor
}

{ #category : #activation }
ClyInquisitorSourceCodeCommand class >> contextMenuOrder [
	^ 150
]

{ #category : #testing }
ClyInquisitorSourceCodeCommand class >> isAbstract [
	^ self = ClyInquisitorSourceCodeCommand 
]

{ #category : #activation }
ClyInquisitorSourceCodeCommand class >> sourceCodeMenuActivation [
    <classAnnotation>
	"Right-click in the source code pane of calypso"
    ^SycDebuggingMenuActivation 
        byItemOf: InqInquisitorMenuGroup order: self contextMenuOrder for: ClyMethodSourceCodeContext
]

{ #category : #execution }
ClyInquisitorSourceCodeCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	
	targetMethod := aToolContext lastSelectedMethod.
	targetNode := aToolContext lastSelectedSourceNode
]
