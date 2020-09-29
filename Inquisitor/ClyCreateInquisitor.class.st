Class {
	#name : #ClyCreateInquisitor,
	#superclass : #ClyInquisitorSourceCodeAndMethodCommand,
	#category : #Inquisitor
}

{ #category : #activation }
ClyCreateInquisitor class >> contextMenuOrder [
	^95
]

{ #category : #accessing }
ClyCreateInquisitor >> defaultMenuIconName [
	^#comments
]

{ #category : #accessing }
ClyCreateInquisitor >> defaultMenuItemName [
	^'Create Inquisitor on test method'
]

{ #category : #accessing }
ClyCreateInquisitor >> execute [
	| i |
	i := Inquisitor new testClass: method methodClass; testMethodName: method selector.
	Inquisitor mainInstance: i.
	i inspect
]
