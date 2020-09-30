Class {
	#name : #ClyInquisitorSourceCodeAndMethodCommand,
	#superclass : #ClyInquisitorSourceCodeCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyInquisitorSourceCodeAndMethodCommand class >> contextMenuOrder [
	^ 100
]

{ #category : #testing }
ClyInquisitorSourceCodeAndMethodCommand class >> isAbstract [
	^ self = ClyInquisitorSourceCodeAndMethodCommand
]

{ #category : #activation }
ClyInquisitorSourceCodeAndMethodCommand class >> methodMenuActivation [
	"Right click on a method in the rightmost pane of calypso"
	<classAnnotation>
	^ CmdContextMenuActivation byItemOf: InquisitorMenuGroup order: self contextMenuOrder for: ClyMethod asCalypsoItemContext
]
