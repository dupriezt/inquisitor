Class {
	#name : #InqUISectionQuestion,
	#superclass : #InqUISection,
	#instVars : [
		'questionDropList',
		'questionActionBar',
		'questionTable'
	],
	#category : #'Inquisitor-UI'
}

{ #category : #specs }
InqUISectionQuestion class >> defaultSpec [
	"Definition of the layout moved to the instance side, for easier editing (no need to switch between the instance and class side in the code browser"
	^ self basicNew defaultSpec_
]

{ #category : #initialization }
InqUISectionQuestion >> connectPresenters [
	"The method connectPresenters defines the interactions between the dif- ferent widgets. By connecting the behaviors of the different widgets it speci- fies the overall presentation, i.e., how the overall UI responds to interactions by the user. Usually this method consists of specifications of actions to per- form when a certain event is received by a widget. The whole interaction flow of the UI then emerges from the propagation of those events."
]

{ #category : #initialization }
InqUISectionQuestion >> defaultSpec_ [
	^ SpBoxLayout newVertical
		add: #questionDropList;
		add: #questionActionBar;
		add: #questionTable;
		yourself
]

{ #category : #initialization }
InqUISectionQuestion >> iconManager [
	"This is where this application gets its icons.
	To see the list of available icons, inspect 'Smalltalk ui icons' and click on the 'Icons' tab"
	^ workbench iconManager
]

{ #category : #initialization }
InqUISectionQuestion >> initializePresenters [
	"The method initializePresenters instantiates, saves in instance vari- ables, and partially configures the different widgets that will be part of the UI.
	In general the initializePresenters method should follow the pattern:
		• widget instantiation
		• widget configuration specification
		• specification of focus order"
	questionDropList := SpDropListPresenter new
		help: 'Select a question';
		items: (OrderedCollection new);
		yourself.
		
	questionActionBar := SpActionBarPresenter new
		add: (self newButton
			icon: (self iconManager iconNamed: #smallInspectIt);
			action: [ workbench buttonActionInspectQuestion ];
			yourself
		);
		yourself.

	questionTable := self newTable
]

{ #category : #initialization }
InqUISectionQuestion >> setModelBeforeInitialization: anObject [
	"This method is called before the initialisation methods (like #initializePresenters), when this presenter instance is created by sending #on: to its class. It is typically used to fill the instance variables of this presenter instance before the initilisation methods get called.
	@anObject is the argument provided to the #on: call. It typically contains all the values to be put into the instance variables"
	workbench := anObject
]
