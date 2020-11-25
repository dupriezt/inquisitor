Class {
	#name : #TestCommand,
	#superclass : #CmdCommand,
	#category : #'Inquisitor-SideStuff'
}

{ #category : #activation }
TestCommand class >> contextMenuOrder [
	^95
]

{ #category : #activation }
TestCommand class >> methodMenuActivation [
	"Right click on a method in the rightmost pane of calypso"
	"<classAnnotation>
	^ CmdContextMenuActivation byItemOf: CmdRootMenuGroup order: 10 for: ClyMethod asCalypsoItemContext"
]

{ #category : #activation }
TestCommand class >> sourceCodeMenuActivation [
	"Right click in the source code pane of calypso"
	"<classAnnotation>
	^ CmdContextMenuActivation byItemOf: CmdRootMenuGroup order: 10 for: ClyMethodSourceCodeContext"
]

{ #category : #accessing }
TestCommand >> defaultMenuIconName [
	^#comments
]

{ #category : #accessing }
TestCommand >> defaultMenuItemName [
	^'TESTTESTTEST'
]

{ #category : #accessing }
TestCommand >> execute [
	self inform: 'executed'
]
