Class {
	#name : #InqUISectionInquisitor,
	#superclass : #InqUISection,
	#instVars : [
		'inquisitorDropList',
		'inquisitorActionBar',
		'setupCodeField',
		'executionCodeField'
	],
	#category : #'Inquisitor-UI'
}

{ #category : #specs }
InqUISectionInquisitor class >> defaultSpec [
	"Definition of the layout moved to the instance side, for easier editing (no need to switch between the instance and class side in the code browser"
	^ self basicNew defaultSpec_
]

{ #category : #initialization }
InqUISectionInquisitor >> connectPresenters [
	"The method connectPresenters defines the interactions between the dif- ferent widgets. By connecting the behaviors of the different widgets it speci- fies the overall presentation, i.e., how the overall UI responds to interactions by the user. Usually this method consists of specifications of actions to per- form when a certain event is received by a widget. The whole interaction flow of the UI then emerges from the propagation of those events."

]

{ #category : #initialization }
InqUISectionInquisitor >> defaultSpec_ [
	^ SpBoxLayout newVertical
		add: #inquisitorDropList withConstraints: (self cstrAt: #inquisitorDropList);
		add: #inquisitorActionBar withConstraints: (self cstrAt: #inquisitorActionBar);
		add: (SpGridLayout new
			"add: 'Setup' at: 1@1;
			add: #setupCodeField at: 2@1;
			add: 'Execution' at: 1@2;
			add: #executionCodeField at: 2@2;"
			add: 'Setup' withConstraints: (self cstrAt: #inquisitorSetupLabel);
			add: #setupCodeField withConstraints: (self cstrAt: #inquisitorSetupCodeField);
			add: 'Execution' withConstraints: (self cstrAt: #inquisitorExecutionLabel);
			add: #executionCodeField withConstraints: (self cstrAt: #inquisitorExecutionCodeField);
			column: 1 withConstraints: (self cstrAt: #inquisitorLabelColumn);
			column: 2 withConstraints: (self cstrAt: #inquisitorCodeColumn);
			row: 1 withConstraints: (self cstrAt: #inquisitorSetupRow);
			row: 2 withConstraints: (self cstrAt: #inquisitorExecutionRow);
			yourself
		);
		yourself
]

{ #category : #initialization }
InqUISectionInquisitor >> iconManager [
	"This is where this application gets its icons.
	To see the list of available icons, inspect 'Smalltalk ui icons' and click on the 'Icons' tab"
	^ workbench iconManager
]

{ #category : #initialization }
InqUISectionInquisitor >> initializePresenters [
	"The method initializePresenters instantiates, saves in instance vari- ables, and partially configures the different widgets that will be part of the UI.
	In general the initializePresenters method should follow the pattern:
		• widget instantiation
		• widget configuration specification
		• specification of focus order"
	inquisitorDropList := SpDropListPresenter new
		help: 'Select an Inquisitor';
		items: OrderedCollection new;
		iconBlock: [ :inq | (inq == InqInquisitor mainInstance) ifTrue: [ self iconManager iconNamed: #smallHome ] ifFalse: [ self iconManager iconNamed: #blank ]  ];
		display: [ :anInquisitor | anInquisitor asStringForClyCommand ]
		yourself.
		
	inquisitorActionBar := SpActionBarPresenter new
		add: (self newButton
			icon: (self iconManager iconNamed: #smallAdd);
			action: [ workbench buttonActionAddInquisitor ];
			yourself
		);
		add: (self newButton
			icon: (self iconManager iconNamed: #smallDelete);
			action: [ workbench buttonActionRemoveInquisitor ];
			yourself
		);
		add: (self newButton
			icon: (self iconManager iconNamed: #smallHome);
			action: [ workbench buttonActionSetMainInquisitor ];
			yourself
		);
		add: (self newButton
			icon: (self iconManager iconNamed: #smallInspectIt);
			action: [ workbench buttonActionInspectInquisitor ];
			yourself
		);
		add: (self newButton
			icon: (self iconManager iconNamed: #smallCogInitialState);
			action: [ workbench buttonActionEditInquisitor ];
			yourself
		);
		flag: 'TODO: remove this button';
		add: (self newButton
			icon: (self iconManager iconNamed: #smallInspectIt);
			action: [ workbench inspect ];
			yourself
		);
		yourself.
		
	setupCodeField := self newCode.
	executionCodeField := self newCode
]

{ #category : #initialization }
InqUISectionInquisitor >> setModelBeforeInitialization: anObject [
	"This method is called before the initialisation methods (like #initializePresenters), when this presenter instance is created by sending #on: to its class. It is typically used to fill the instance variables of this presenter instance before the initilisation methods get called.
	@anObject is the argument provided to the #on: call. It typically contains all the values to be put into the instance variables"
	workbench := anObject
]
