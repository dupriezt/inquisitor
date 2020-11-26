Class {
	#name : #InqTestCommand,
	#superclass : #CmdCommand,
	#category : #'Inquisitor-SideStuff'
}

{ #category : #activation }
InqTestCommand class >> contextMenuOrder [
	^95
]

{ #category : #activation }
InqTestCommand class >> methodMenuActivation [
	"Right click on a method in the rightmost pane of calypso"
	"<classAnnotation>
	^ CmdContextMenuActivation byItemOf: CmdRootMenuGroup order: 10 for: ClyMethod asCalypsoItemContext"
]

{ #category : #activation }
InqTestCommand class >> sourceCodeMenuActivation [
	"Right click in the source code pane of calypso"
	"<classAnnotation>
	^ CmdContextMenuActivation byItemOf: CmdRootMenuGroup order: 10 for: ClyMethodSourceCodeContext"
]

{ #category : #accessing }
InqTestCommand >> defaultMenuIconName [
	^#comments
]

{ #category : #accessing }
InqTestCommand >> defaultMenuItemName [
	^'TESTTESTTEST'
]

{ #category : #accessing }
InqTestCommand >> execute [
	self inform: 'executed'
]
