Class {
	#name : #InqDefaultCapturePointsPresenter,
	#superclass : #InqCapturePointsAbstractPresenter,
	#instVars : [
		'capturePointsTable'
	],
	#category : #'Inquisitor-UI'
}

{ #category : #testing }
InqDefaultCapturePointsPresenter class >> canHandle: anInqInquisitorQuestion [
	"Whether this class can be used to show the capture points of anInqInquisitorQuestion"
	^ true
]

{ #category : #specs }
InqDefaultCapturePointsPresenter class >> defaultSpec [
	"Definition of the layout moved to the instance side, for easier editing (no need to switch between the instance and class side in the code browser"
	^ self basicNew defaultSpec_
]

{ #category : #specs }
InqDefaultCapturePointsPresenter class >> pageName [
	"Return the name of this presenter, to be displayed as the title of the notebook page that will contain this presenter"
	^ 'Default'
]

{ #category : #initialization }
InqDefaultCapturePointsPresenter >> capturePoints [
	^ question capturePoints
]

{ #category : #initialization }
InqDefaultCapturePointsPresenter >> defaultSpec_ [
	^ SpBoxLayout newVertical
		add: #capturePointsTable;
		yourself
]

{ #category : #initialization }
InqDefaultCapturePointsPresenter >> initializePresenters [
	"The method initializePresenters instantiates, saves in instance vari- ables, and partially configures the different widgets that will be part of the UI.
	In general the initializePresenters method should follow the pattern:
		• widget instantiation
		• widget configuration specification
		• specification of focus order"
	capturePointsTable := self newTable
		beResizable;
		items: self capturePoints;
		addColumn: ((SpStringTableColumn title: 'TimeIndex' evaluated: #timeIndex) width: 70; yourself);
		addColumn: ((SpStringTableColumn title: 'Value' evaluated: [:cp | cp capturedValue]) width: 150; yourself);
		addColumn: ((SpStringTableColumn title: 'MethodInvocation' evaluated: [:cp | cp methodInvocation asStringForCapturePointsTable]) width: 150; yourself);
		addColumn: ((SpStringTableColumn title: 'Receiver' evaluated: [:cp | cp receiver]) width: 150; yourself);
		yourself.
	
		
]
