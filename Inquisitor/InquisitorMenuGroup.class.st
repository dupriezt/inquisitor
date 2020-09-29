Class {
	#name : #InquisitorMenuGroup,
	#superclass : #CmdMenuGroup,
	#category : #Inquisitor
}

{ #category : #parents }
InquisitorMenuGroup class >> parentGroup [
    ^ ClyDebuggingMenuGroup
]

{ #category : #accessing }
InquisitorMenuGroup >> iconName [
	^#comments
]

{ #category : #testing }
InquisitorMenuGroup >> isInlined [
	^false
]

{ #category : #accessing }
InquisitorMenuGroup >> name [
	^ 'Inquisitor'
]

{ #category : #testing }
InquisitorMenuGroup >> order [
	^0.5
]
