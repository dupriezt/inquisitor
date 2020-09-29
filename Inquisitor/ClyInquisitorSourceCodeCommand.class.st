Class {
	#name : #ClyInquisitorSourceCodeCommand,
	#superclass : #ClyInquisitorCommand,
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
        byItemOf: InquisitorMenuGroup order: self contextMenuOrder for: ClyMethodSourceCodeContext
]
