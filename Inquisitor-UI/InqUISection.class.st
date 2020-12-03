Class {
	#name : #InqUISection,
	#superclass : #SpPresenter,
	#instVars : [
		'workbench'
	],
	#category : #'Inquisitor-UI'
}

{ #category : #accessing }
InqUISection >> cstrAt: aKey [
	"Shorthand to make defaultSpec_ method more concise"
	^ workbench cstrAt: aKey
]

{ #category : #'accessing model' }
InqUISection >> setModelBeforeInitialization: anObject [
	"This method is called before the initialisation methods (like #initializePresenters), when this presenter instance is created by sending #on: to its class. It is typically used to fill the instance variables of this presenter instance before the initilisation methods get called.
	@anObject is the argument provided to the #on: call. It typically contains all the values to be put into the instance variables"
	workbench := anObject
]
