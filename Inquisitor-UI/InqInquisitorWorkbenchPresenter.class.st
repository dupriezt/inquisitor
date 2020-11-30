Class {
	#name : #InqInquisitorWorkbenchPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'pointTable',
		'textField',
		'executeButton',
		'inspectButton',
		'inquisitorDropList',
		'inquisitorActionBar',
		'inquisitorExecutionCode',
		'questionDropList',
		'questionDetail',
		'capturePointsNotebook',
		'capturePointsPlayground'
	],
	#category : #'Inquisitor-UI'
}

{ #category : #specs }
InqInquisitorWorkbenchPresenter class >> defaultSpec [
	"Definition of the layout moved to the instance side, for easier editing (no need to switch between the instance and class side in the code browser"
	^ self basicNew defaultSpec_
]

{ #category : #specs }
InqInquisitorWorkbenchPresenter class >> open [
	<script>
	(self on: nil "model object, will be used as argument in #setModelBeforeInitialization:") openWithSpec.
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> buttonActionAddInquisitor [
	self flag: 'finish'.
	self inform: 'add inquisitor'
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> buttonActionRemoveInquisitor [
	self flag: 'Todo: finish'.
	self inform: 'remove inquisitor'
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> buttonActionSetMainInquisitor [
	self flag: 'Todo: finish'.
	self inform: 'set main inquisitor'
]

{ #category : #specs }
InqInquisitorWorkbenchPresenter >> buttonConstraints [
	"Defines a common constraint to be used for all buttons"
	^ [ :cstr | cstr width: 120. cstr height: 20 ]
	
]

{ #category : #data }
InqInquisitorWorkbenchPresenter >> collectionOfPoints [
	| c |
	c := OrderedCollection new.
	c add: (Point x: 1 y: 5).
	c add: (Point x: 48 y: 1).
	c add: (Point x: 5 y: 6).
	c add: (Point x: 1 y: 48).
	c add: (Point x: 3 y: 92).
	c add: (Point x: 4 y: 67).
	c add: (Point x: 8 y: 5).
	c add: (Point x: 16 y: 22).
	c add: (Point x: 22 y: 21).
	c add: (Point x: 2 y: 31).
	c add: (Point x: 43 y: 2).
	^ c
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> connectPresenters [
	"The method connectPresenters defines the interactions between the dif- ferent widgets. By connecting the behaviors of the different widgets it speci- fies the overall presentation, i.e., how the overall UI responds to interactions by the user. Usually this method consists of specifications of actions to per- form when a certain event is received by a widget. The whole interaction flow of the UI then emerges from the propagation of those events."
	"inspectButton action: [ self inspectSelectedItem ].
	executeButton action: [ self inform: 'Todo' ]"
]

{ #category : #specs }
InqInquisitorWorkbenchPresenter >> defaultSpec_ [
	
	^ SpPanedLayout newHorizontal
		add: (SpBoxLayout newVertical "Left side"
			add: #inquisitorDropList;
			add: #inquisitorActionBar;
			add: #inquisitorExecutionCode;
			add: #questionDropList;
			add: #questionDetail;
			yourself
		);
		add: (SpBoxLayout newVertical
			add: #capturePointsNotebook;
			add: #capturePointsPlayground;
			yourself
		); "Right side"
		yourself.


"	^ SpBoxLayout newVertical
		add: (SpPanedLayout newHorizontal
			add: #pointTable;
			add: #textField;
			yourself
		);
		add: (SpBoxLayout newHorizontal
			add: #inspectButton withConstraints: self buttonConstraints;
			add: #executeButton withConstraints: self buttonConstraints;
			yourself	
		) withConstraints: [ :cstr | cstr height: 30 ];
		yourself."
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> executeCode [
]

{ #category : #icon }
InqInquisitorWorkbenchPresenter >> iconManager [
	"This is where this application gets its icons.
	To see the list of available icons, inspect 'Smalltalk ui icons' and click on the 'Icons' tab"
	^ Smalltalk ui icons
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> initializePresenters [
	"The method initializePresenters instantiates, saves in instance vari- ables, and partially configures the different widgets that will be part of the UI.
	In general the initializePresenters method should follow the pattern:
		• widget instantiation
		• widget configuration specification
		• specification of focus order"
		
	inquisitorDropList := SpDropListPresenter new
		help: 'Select an Inquisitor';
		items: (OrderedCollection new add: 1; yourself);
		yourself.
		
	inquisitorActionBar := SpActionBarPresenter new
		add: (self newButton
			icon: (self iconManager iconNamed: #smallAdd);
			action: [ self buttonActionAddInquisitor ];
			yourself
		);
		add: (self newButton
			icon: (self iconManager iconNamed: #smallDelete);
			action: [ self buttonActionRemoveInquisitor ];
			yourself
		);
		add: (self newButton
			icon: (self iconManager iconNamed: #smallHome);
			action: [ self buttonActionSetMainInquisitor ];
			yourself
		);
		yourself.
	
	inquisitorExecutionCode := SpCodePresenter new.
	
	questionDropList := SpDropListPresenter new
		help: 'Select a question';
		items: (OrderedCollection new add: 1; yourself);
		yourself.
		
	questionDetail := SpTablePresenter new.
	
	capturePointsNotebook := SpNotebookPresenter new.
	
	capturePointsPlayground := StPlayground new.
	
	self flag: 'Todo: remove comment'
	"| indexColumn xColumn yColumn |
	pointTable := self newTable. ""SpTablePresenter""
	indexColumn := SpIndexTableColumn new width: 40; title: 'Index'; yourself.
	xColumn := SpStringTableColumn new evaluated: [:item | item x]; title: 'X'; width: 60; yourself.
	yColumn := SpStringTableColumn new evaluated: [:item | item y]; title: 'Y'; width: 60; yourself.
	pointTable addColumn: indexColumn; addColumn: xColumn; addColumn: yColumn.
	pointTable items: self collectionOfPoints.
		
	textField := self newText. ""SpTextPresenter""
	textField placeholder: 'placeholder text'; autoAccept: true. ""You cans et something to happen when the user 'accepts' the code (ctrl-s, like to save a method)""
	
	""These two buttons get their actions assigned in #connectPresenters""
	inspectButton := self newButton. ""SpButtonPresenter""
	inspectButton label: 'Inspect Selected'; icon: (self iconManager iconNamed: #glamorousInspect).
	
	executeButton := self newButton. ""SpButtonPresenter""
	executeButton label: 'Execute'; icon: (self iconManager iconNamed: #glamorousGo).
	
	""I don't know how to do focus order"""
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Inquisitor Workbench';
		initialExtent: 860@655; "initial width@height of the window" "Size of a calypso browser"
		windowIcon: (self iconManager iconNamed: #home) "Icon that will be shown in the bottom windowbar for this window"
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> inspectSelectedItem [
	pointTable selectedItems inspect.
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> setModelBeforeInitialization: anObject [
	"This method is called before the initialisation methods (like #initializePresenters), when this presenter instance is created by sending #on: to its class. It is typically used to fill the instance variables of this presenter instance before the initilisation methods get called.
	@anObject is the argument provided to the #on: call. It typically contains all the values to be put into the instance variables"
	
	"instanceVariable1 := anObject getValueForInstanceVariable1"
]
