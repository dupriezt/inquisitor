Class {
	#name : #InqUISectionInquisitor,
	#superclass : #InqUISection,
	#instVars : [
		'inquisitorDropList',
		'inquisitorActionBar',
		'setupCodeField',
		'executionCodeField',
		'addInquisitorButton',
		'removeInquisitorButton',
		'setMainInquisitorButton',
		'inspectInquisitorButton'
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
		add: (SpBoxLayout newHorizontal
			add: (SpBoxLayout newVertical
				add: 'Setup' withConstraints: (self cstrAt: #inquisitorSetupLabel);
				add: 'Execution' withConstraints: (self cstrAt: #inquisitorExecutionLabel);
				yourself
			) withConstraints: (self cstrAt: #inquisitorLabelColumn);
			add: (SpBoxLayout newVertical
				add: #setupCodeField withConstraints: (self cstrAt: #inquisitorSetupCodeField);
				add: #executionCodeField withConstraints: (self cstrAt: #inquisitorExecutionCodeField);
				yourself
			) withConstraints: (self cstrAt: #inquisitorCodeColumn);
			yourself
		);
		yourself.
"		add: (SpGridLayout new
			beColumnNotHomogeneous;
			""beRowNotHomogeneous;""
			""add: 'Setup' at: 1@1;
			add: #setupCodeField at: 2@1;
			add: 'Execution' at: 1@2;
			add: #executionCodeField at: 2@2;""
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
		yourself"
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
	
	addInquisitorButton := self newButton
			icon: (self iconManager iconNamed: #smallAdd);
			action: [ workbench buttonActionAddInquisitor ];
			help: 'Create inquisitor';
			yourself.
	removeInquisitorButton := self newButton
			icon: (self iconManager iconNamed: #smallDelete);
			action: [ workbench buttonActionRemoveInquisitor ];
			help: 'Delete selected inquisitor';
			yourself.
	setMainInquisitorButton := self newButton
			icon: (self iconManager iconNamed: #smallHome);
			action: [ workbench buttonActionSetMainInquisitor ];
			help: 'Set selected inquisitor as Main Inquisitor';
			yourself.
	inspectInquisitorButton := self newButton
			icon: (self iconManager iconNamed: #smallInspectIt);
			action: [ workbench buttonActionInspectInquisitor ];
			help: 'Inspect selected inquisitor';
			yourself.
	inquisitorActionBar := SpActionBarPresenter new
		add: addInquisitorButton;
		add: removeInquisitorButton;
		add: setMainInquisitorButton;
		add: inspectInquisitorButton;
		flag: 'TODO: remove this button vvv';
		add: (self newButton
			icon: (self iconManager iconNamed: #smallInspectIt);
			action: [ workbench inspect ];
			help: 'Inspect workbench';
			yourself
		);
		yourself.
		
	setupCodeField := self newCode
		whenTextChangedDo: [ :newText | workbench uiIsMuted ifFalse: [inquisitorDropList selectedItem setupCode: newText asString]];
		yourself.
	executionCodeField := self newCode
		whenTextChangedDo: [ :newText | workbench uiIsMuted ifFalse: [inquisitorDropList selectedItem executionCode: newText asString]];
		yourself
]

{ #category : #initialization }
InqUISectionInquisitor >> setModelBeforeInitialization: anObject [
	"This method is called before the initialisation methods (like #initializePresenters), when this presenter instance is created by sending #on: to its class. It is typically used to fill the instance variables of this presenter instance before the initilisation methods get called.
	@anObject is the argument provided to the #on: call. It typically contains all the values to be put into the instance variables"
	workbench := anObject
]
