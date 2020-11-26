Class {
	#name : #InqValueCheckPopup,
	#superclass : #SpPresenter,
	#instVars : [
		'node',
		'descriptionLabel',
		'nodeLabel',
		'expressionField',
		'cancelButton',
		'submitButton'
	],
	#category : #Inquisitor
}

{ #category : #specs }
InqValueCheckPopup class >> defaultSpec [
	"Definition of the layout moved to the instance side, for easier editing (no need to switch between the instance and class side in the code browser"
	^ self basicNew defaultSpec_
]

{ #category : #specs }
InqValueCheckPopup class >> open [
	<script>
	| data |
	data := Dictionary new.
	data at: #node put: (thisContext method ast body statements at: 1).
	(self on: data "model object, will be used as argument in #setModelBeforeInitialization:") openWithSpec.
]

{ #category : #specs }
InqValueCheckPopup >> buttonConstraints [
	"Defines a common constraint to be used for all buttons"
	^ [ :cstr | cstr width: 120. cstr height: 20 ]
	
]

{ #category : #initialization }
InqValueCheckPopup >> connectPresenters [
	"The method connectPresenters defines the interactions between the dif- ferent widgets. By connecting the behaviors of the different widgets it speci- fies the overall presentation, i.e., how the overall UI responds to interactions by the user. Usually this method consists of specifications of actions to per- form when a certain event is received by a widget. The whole interaction flow of the UI then emerges from the propagation of those events."
	cancelButton action: [ self window close ].
	submitButton action: [ self submitAction ]
]

{ #category : #specs }
InqValueCheckPopup >> defaultSpec_ [

	^ SpBoxLayout newVertical
		add: #descriptionLabel withConstraints: self textHeightConstraint;
		add: #nodeLabel withConstraints: self textHeightConstraint;
		add: #expressionField;
		add: (SpBoxLayout newHorizontal
			add: #cancelButton withConstraints: self buttonConstraints;
			add: #submitButton withConstraints: self buttonConstraints;
			yourself	
		) withConstraints: [ :cstr | cstr height: 30 ];
		yourself.
]

{ #category : #icon }
InqValueCheckPopup >> iconManager [
	"This is where this application gets its icons.
	To see the list of available icons, inspect 'Smalltalk ui icons' and click on the 'Icons' tab"
	^ Smalltalk ui icons
]

{ #category : #initialization }
InqValueCheckPopup >> initializePresenters [
	"The method initializePresenters instantiates, saves in instance vari- ables, and partially configures the different widgets that will be part of the UI.
	In general the initializePresenters method should follow the pattern:
		• widget instantiation
		• widget configuration specification
		• specification of focus order"
		
	descriptionLabel := self newLabel label: 'Description'; yourself.
	
	nodeLabel := self newLabel label: ('On node: ', node asString); yourself.
		
	expressionField := self newText. "SpTextPresenter"
	expressionField placeholder: 'Enter expression'; autoAccept: true. "You cans et something to happen when the user 'accepts' the code (ctrl-s, like to save a method)"
	
	"These two buttons get their actions assigned in #connectPresenters"
	cancelButton := self newButton. "SpButtonPresenter"
	cancelButton label: 'Cancel'; icon: (self iconManager iconNamed: #glamorousCancel).
	
	submitButton := self newButton. "SpButtonPresenter"
	submitButton label: 'Submit'; icon: (self iconManager iconNamed: #glamorousAccept).
	
	"I don't know how to do focus order"
]

{ #category : #initialization }
InqValueCheckPopup >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Enter Expression';
		initialExtent: 500@280; "initial width@height of the window"
		windowIcon: (self iconManager iconNamed: #home) "Icon that will be shown in the bottom windowbar for this window"
]

{ #category : #initialization }
InqValueCheckPopup >> setModelBeforeInitialization: anObject [
	"This method is called before the initialisation methods (like #initializePresenters), when this presenter instance is created by sending #on: to its class. It is typically used to fill the instance variables of this presenter instance before the initilisation methods get called.
	@anObject is the argument provided to the #on: call. It typically contains all the values to be put into the instance variables"
	
	"instanceVariable1 := anObject getValueForInstanceVariable1"
	anObject isDictionary ifFalse: [ ^ self error: 'anObject is not a dictionary' ].
	node := anObject at: #node
]

{ #category : #initialization }
InqValueCheckPopup >> submitAction [
	InqInquisitor askQuestion: (InqValueCheckQuestion newForNode: node andExpression: expressionField text).
	self window close
	
]

{ #category : #specs }
InqValueCheckPopup >> textHeightConstraint [
	"Defines a common height constraint to be used for all text"
	^ [ :cstr | cstr height: 20 ]
	
]
