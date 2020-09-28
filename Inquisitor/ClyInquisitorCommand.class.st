Class {
	#name : #ClyInquisitorCommand,
	#superclass : #ClyDebuggingCommand,
	#category : #Inquisitor
}

{ #category : #testing }
ClyInquisitorCommand class >> isAbstract [
	^ self = ClyInquisitorCommand
]

{ #category : #activation }
ClyInquisitorCommand class >> sourceCodeMenuActivation [
    <classAnnotation>

    ^SycDebuggingMenuActivation 
        byItemOf: InquisitorMenuGroup order: self contextMenuOrder for: ClyMethodSourceCodeContext
]
