Class {
	#name : #InqCapturePointsAbstractPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'question'
	],
	#category : #'Inquisitor-UI'
}

{ #category : #testing }
InqCapturePointsAbstractPresenter class >> canHandle: anInqInquisitorQuestion [
	"Whether this class can be used to show the capture points of anInqInquisitorQuestion"
	^ self subclassResponsibility 
]

{ #category : #testing }
InqCapturePointsAbstractPresenter class >> isAbstract [
	^ self == InqCapturePointsAbstractPresenter 
]

{ #category : #specs }
InqCapturePointsAbstractPresenter class >> pageName [
	"Return the name of this presenter, to be displayed as the title of the notebook page that will contain this presenter"
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
InqCapturePointsAbstractPresenter >> selectedCapturePoint [
 "Must return the currently selected capture point. Nil if there is none"
	self subclassResponsibility
]

{ #category : #'accessing model' }
InqCapturePointsAbstractPresenter >> setModelBeforeInitialization: anObject [
	"This method is called before the initialisation methods (like #initializePresenters), when this presenter instance is created by sending #on: to its class. It is typically used to fill the instance variables of this presenter instance before the initilisation methods get called.
	@anObject is the argument provided to the #on: call. It typically contains all the values to be put into the instance variables"
	question := anObject.
]
