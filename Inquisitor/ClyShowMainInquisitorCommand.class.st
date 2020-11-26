Class {
	#name : #ClyShowMainInquisitorCommand,
	#superclass : #ClyInquisitorSourceCodeAndMethodCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyShowMainInquisitorCommand class >> canBeExecutedInContext: aToolContext [
	^ true
]

{ #category : #activation }
ClyShowMainInquisitorCommand class >> contextMenuOrder [
	^80
]

{ #category : #accessing }
ClyShowMainInquisitorCommand >> defaultMenuIconName [
	self isMainInquisitorDefined ifFalse: [ ^ #error ] ifTrue: [ ^ #glamorousInspect ]
]

{ #category : #accessing }
ClyShowMainInquisitorCommand >> defaultMenuItemName [
	self isMainInquisitorDefined ifFalse: [ ^ 'No main inquisitor defined. Right-click on a test method' ] ifTrue: [ ^ 'Inquisited Test: ', InqInquisitor mainInstance testMethodFullName ].
]

{ #category : #accessing }
ClyShowMainInquisitorCommand >> execute [
	self isMainInquisitorDefined ifTrue: [ InqInquisitor mainInstance inspect ]
]

{ #category : #accessing }
ClyShowMainInquisitorCommand >> isMainInquisitorDefined [
	^ InqInquisitor mainInstance isNotNil
]
