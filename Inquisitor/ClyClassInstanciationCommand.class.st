Class {
	#name : #ClyClassInstanciationCommand,
	#superclass : #ClyInquisitorClassCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyClassInstanciationCommand class >> browserContextMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation
		byItemOf: InqInquisitorMenuGroup
		order: 99
		for: ClyClass asCalypsoItemContext
]

{ #category : #accessing }
ClyClassInstanciationCommand >> defaultMenuIconName [
	^#comments
]

{ #category : #execution }
ClyClassInstanciationCommand >> defaultMenuItemName [
	^'Class Instanciation'
]

{ #category : #execution }
ClyClassInstanciationCommand >> execute [
	self inform: self class name asString, ' executed for class: ', self targetClass name asString
]
