Class {
	#name : #InqInquisitorMenuGroup,
	#superclass : #CmdMenuGroup,
	#category : #Inquisitor
}

{ #category : #parents }
InqInquisitorMenuGroup class >> parentGroup [
    ^ ClyDebuggingMenuGroup
]

{ #category : #accessing }
InqInquisitorMenuGroup >> iconName [
	^#confirm
]

{ #category : #testing }
InqInquisitorMenuGroup >> isInlined [
	^false
]

{ #category : #accessing }
InqInquisitorMenuGroup >> name [
	^ 'Inquisitor'
]

{ #category : #testing }
InqInquisitorMenuGroup >> order [
	^0.5
]
