Class {
	#name : #ClyInquisitorMethodCommand,
	#superclass : #ClyInquisitorCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyInquisitorMethodCommand class >> contextMenuOrder [
	^ 100
]

{ #category : #testing }
ClyInquisitorMethodCommand class >> isAbstract [
	^ self = ClyInquisitorMethodCommand
]

{ #category : #activation }
ClyInquisitorMethodCommand class >> methodMenuActivation [
	"Right click on a method in the rightmost pane of calypso"
	<classAnnotation>
	^ CmdContextMenuActivation byItemOf: InquisitorMenuGroup order: 10 for: ClyMethod asCalypsoItemContext
]
