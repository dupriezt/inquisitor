Class {
	#name : #InqInquisitorWorkbenchPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'inquisitorDropList',
		'inquisitorActionBar',
		'questionDropList',
		'questionDetail',
		'capturePointsNotebook',
		'capturePointsPlayground',
		'questionActionBar',
		'inquisitorSection',
		'questionSection',
		'capturePointsSection',
		'inquisitorSectionHolder',
		'questionSectionHolder',
		'capturePointsSectionHolder',
		'capturePointsActionBar',
		'capturePointsPagesDictionary',
		'setupCodeField',
		'executionCodeField',
		'questionQuickViewTable',
		'addInquisitorButton',
		'removeInquisitorButton',
		'setMainInquisitorButton',
		'inspectInquisitorButton',
		'uiIsMuted'
	],
	#classVars : [
		'constraints'
	],
	#category : #'Inquisitor-UI'
}

{ #category : #'as yet unclassified' }
InqInquisitorWorkbenchPresenter class >> constraints: aDictionary [
	constraints := aDictionary
]

{ #category : #accessing }
InqInquisitorWorkbenchPresenter class >> cstrAt: aSymbol [
	"Can maybe be optimised by creating an instance and keeping it around to answer #cstrAt: calls, instead of recreating an instance every time"
	^ constraints at: aSymbol
]

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
	InqInquisitor newForCode: '' withSetupCode: ''
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> buttonActionInspectAllCapturePoints [
	questionDropList selectedItem capturePoints inspect
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> buttonActionInspectCapturePoint [
	self selectedCapturePointDo: [ :capturePoint | capturePoint inspect ] ifNilDo: [ self inform: 'No capture point selected' ].
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> buttonActionInspectInquisitor [
	inquisitorDropList selectedItem inspect
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> buttonActionInspectQuestion [
	questionDropList selectedItem inspect
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> buttonActionOpenCapturePoint [
	"self inform: 'Open Capture point'."
	self selectedCapturePointDo: [ :cp | inquisitorDropList selectedItem openExecutionOnCapturePoint: cp ] ifNilDo: [ self inform: 'No capture point selected' ]

]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> buttonActionReAskQuestion [
	self flag: 'TODO'.
	self inform: 'Re-ask selected question TODO'.
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> buttonActionRemoveInquisitor [
	InqInquisitor removeInstance: inquisitorDropList selectedItem
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> buttonActionSetMainInquisitor [
	InqInquisitor mainInstance: inquisitorDropList selectedItem
]

{ #category : #specs }
InqInquisitorWorkbenchPresenter >> buttonConstraints [
	"Defines a common constraint to be used for all buttons"
	^ [ :cstr | cstr width: 120. cstr height: 20 ]
	
]

{ #category : #accessing }
InqInquisitorWorkbenchPresenter >> capturePointsPagesDictionary [
	capturePointsPagesDictionary ifNil: [ capturePointsPagesDictionary := Dictionary new ].
	^ capturePointsPagesDictionary
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> connectPresenters [
	"The method connectPresenters defines the interactions between the dif- ferent widgets. By connecting the behaviors of the different widgets it speci- fies the overall presentation, i.e., how the overall UI responds to interactions by the user. Usually this method consists of specifications of actions to per- form when a certain event is received by a widget. The whole interaction flow of the UI then emerges from the propagation of those events."
	inquisitorDropList whenSelectedItemChangedDo: [ :newlySelectedInquisitor |
		self uiIsMuted ifFalse: [ self whenInquisitorIsSelected: newlySelectedInquisitor].
	].
	questionDropList whenSelectedItemChangedDo: [ :newlySelectedQuestion |
		self uiIsMuted ifFalse: [ self whenQuestionIsSelected: newlySelectedQuestion].
	].
	self postInitialisation.
]

{ #category : #specs }
InqInquisitorWorkbenchPresenter >> constraints [
	"Layout constraints for the elements defined in defaultSpec_ method"
	| csts dropListHeight actionBarHeight |
	"If constraints is nil:"
	dropListHeight := 30.
	actionBarHeight := 30.
	csts := Dictionary new.
	csts at: #inquisitorDropList put: [ :c | c height: dropListHeight].
	csts at: #inquisitorActionBar put: [ :c | c height: actionBarHeight].
	csts at: #inquisitorSetupLabel put: [ :c | c "position: 1@1"].
	csts at: #inquisitorSetupCodeField put: [ :c | c padding: 1" position: 2@1"].
	csts at: #inquisitorExecutionLabel put: [ :c | c "position: 1@2"].
	csts at: #inquisitorExecutionCodeField put: [ :c | c "position: 2@2"].
	csts at: #inquisitorLabelColumn put: [ :c | c expand: false; padding: 5].
	csts at: #inquisitorCodeColumn put: [ :c | c expand: true].
	csts at: #inquisitorSetupRow put: [ :c | c ].
	csts at: #inquisitorExecutionRow put: [ :c | c ].
	
	csts at: #questionDropList put: [ :c | c height: dropListHeight].
	csts at: #questionActionBar put: [ :c | c height: actionBarHeight].
	csts at: #questionQuickViewTable put: [ :c | c ].

	csts at: #capturePointsActionBar put: [ :c | c height: actionBarHeight ].	
	csts at: #capturePointsNotebook put: [ :c | c ].
	csts at: #capturePointsPlayground put: [ :c | c ].
	
	csts at: #inquisitorSection put: [ :c | c "expand: false" ].
	csts at: #questionSection put: [ :c | c "expand: false"].
	csts at: #topSection put: [ :c | c ]. "inquisitorSection + questionSection"
	csts at: #capturePointsSection put: [ :c | ].
	^ csts
	
	
	      
	
]

{ #category : #specs }
InqInquisitorWorkbenchPresenter >> cstrAt: aSymbol [
	"Shorthand to make defaultSpec_ method more concise"
	^ self class cstrAt: aSymbol
]

{ #category : #specs }
InqInquisitorWorkbenchPresenter >> defaultSpec_ [
	self class constraints: self constraints.
	^ SpPanedLayout newVertical
		add: (SpBoxLayout newHorizontal
			add: #inquisitorSectionHolder withConstraints: (self cstrAt: #inquisitorSection);
			add: #questionSectionHolder withConstraints: (self cstrAt: #questionSection);
			yourself
		) withConstraints: (self cstrAt: #topSection);
		add: #capturePointsSectionHolder withConstraints: (self cstrAt: #capturePointsSection);
		yourself.
	
	"^ SpPanedLayout newHorizontal
		add: (SpBoxLayout newVertical ""Left side""
			add: #inquisitorDropList withConstraints: (self cstrAt: #inquisitorDropList);
			add: #inquisitorActionBar withConstraints: (self cstrAt: #inquisitorActionBar);
			add: #inquisitorExecutionCode withConstraints: (self cstrAt: #inquisitorExecutionCode);
			add: #questionDropList withConstraints: (self cstrAt: #questionDropList);
			add: #questionActionBar withConstraints: (self cstrAt: #questionActionBar);
			add: #questionDetail withConstraints: (self cstrAt: #questionDetail);
			yourself
		) withConstraints: (self cstrAt: #leftPanel);
		add: (SpBoxLayout newVertical
			add: #capturePointsNotebook withConstraints: (self cstrAt: #capturePointsNotebook);
			add: #capturePointsPlayground withConstraints: (self cstrAt: #capturePointsPlayground);
			yourself
		) withConstraints: (self cstrAt: #rightPanel); ""Right side""
		yourself."


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

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> eventInquisitorAdded: anInqInquisitorAdded [
	self setItemsOfInquisitorDropList: InqInquisitor instances.
	anInqInquisitorAdded inquisitor updateAnnouncer weak when: InqInquisitorUpdated send: #eventInquisitorUpdated: to: self.
	inquisitorDropList selectItem: anInqInquisitorAdded inquisitor
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> eventInquisitorMainInstanceChanged: anInqInquisitorMainInstanceChanged [
	| selected |
	selected := inquisitorDropList selectedItem.
	self setItemsOfInquisitorDropList: InqInquisitor instances.
	selected ifNotNil: [inquisitorDropList selectItem: selected].
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> eventInquisitorRemoved: anInqInquisitorRemoved [
	| selected |
	anInqInquisitorRemoved inquisitor updateAnnouncer unsubscribe: self.
	selected := inquisitorDropList selectedItem.
	inquisitorDropList resetSelection.
	"If the removed inquisitor was not the last, simply update the list. It is was the list, replace the list with a list containing a single empty inquisitor"
	(inquisitorDropList items size > 1) ifTrue: [
		self setItemsOfInquisitorDropList: InqInquisitor instances
	] ifFalse: [
		self setItemsOfInquisitorDropList: ((OrderedCollection new) add: InqEmptyInquisitor new; yourself)
	].
	(selected == anInqInquisitorRemoved inquisitor) ifFalse: [inquisitorDropList selectItem: selected] ifTrue: [ inquisitorDropList selectIndex: 1].
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> eventInquisitorUpdated: anInqInquisitorUpdated [
	| selected |
	selected := inquisitorDropList selectedItem.
	self setItemsOfInquisitorDropList: InqInquisitor instances. "The content of the list of inquisitor instances did not change, but resetting the items of the drop list is the only way I found to make sure their display block (their name in the droplist) are re-evaluated"
	selected ifNotNil: [inquisitorDropList selectItem: selected].
	self flag: 'todo'.
	"update question list. Maybe not needed because the selected inquisitor is reselected"
	
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
	inquisitorSection := InqUISectionInquisitor on: self.
	inquisitorSectionHolder := self newNotebook addPageTitle: 'Inquisitor' provider: [ 
		inquisitorSection
	].
	questionSection := InqUISectionQuestion on: self.
	questionSectionHolder := self newNotebook addPageTitle: 'Question' provider: [ 
		questionSection
	].
	capturePointsSection := InqUISectionCapturePoints on: self.
	capturePointsSectionHolder := self newNotebook addPageTitle: 'Capture Points' provider: [ 
		capturePointsSection
	].
		
	inquisitorDropList := self presenterNamed: #inquisitorDropList fromUISection: inquisitorSection.		
	inquisitorActionBar := self presenterNamed: #inquisitorActionBar fromUISection: inquisitorSection.
	addInquisitorButton := self presenterNamed: #addInquisitorButton fromUISection: inquisitorSection.
	removeInquisitorButton := self presenterNamed: #removeInquisitorButton fromUISection: inquisitorSection.
	setMainInquisitorButton := self presenterNamed: #setMainInquisitorButton fromUISection: inquisitorSection.
	inspectInquisitorButton := self presenterNamed: #inspectInquisitorButton fromUISection: inquisitorSection.
	
	setupCodeField := self presenterNamed: #setupCodeField fromUISection: inquisitorSection.
	executionCodeField := self presenterNamed: #executionCodeField fromUISection: inquisitorSection.
	questionDropList := self presenterNamed: #questionDropList fromUISection: questionSection.
	questionActionBar := self presenterNamed: #questionActionBar fromUISection: questionSection.
	questionQuickViewTable := self presenterNamed: #questionQuickViewTable fromUISection: questionSection.
	capturePointsNotebook := self presenterNamed: #capturePointsNotebook fromUISection: capturePointsSection.
	capturePointsActionBar := self presenterNamed: #capturePointsActionBar fromUISection: capturePointsSection.
	capturePointsPlayground := self presenterNamed: #capturePointsPlayground fromUISection: capturePointsSection.
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Inquisitor Workbench';
		initialExtent: 860@655; "initial width@height of the window" "Size of a calypso browser"
		windowIcon: (self iconManager iconNamed: #home) "Icon that will be shown in the bottom windowbar for this window"
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> postInitialisation [
	"Executed after #initializePresenters and #connectPresenters"
	inquisitorDropList items isEmpty ifFalse: [ inquisitorDropList selectIndex: 1 ]. "After everything is initialised, to trigger a refresh of the Ui as if the user had selected the first inquisitor in the list."
	InqInquisitor instanceLogAnnouncer weak when: InqInquisitorAdded send: #eventInquisitorAdded: to: self.
	InqInquisitor instanceLogAnnouncer weak when: InqInquisitorRemoved send: #eventInquisitorRemoved: to: self.
	InqInquisitor instanceLogAnnouncer weak when: InqInquisitorMainInstanceChanged send: #eventInquisitorMainInstanceChanged: to: self.
	self setItemsOfInquisitorDropList: InqInquisitor instances.
	inquisitorDropList selectIndex: 1.
	uiIsMuted := false.
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> presenterNamed: aSymbol fromUISection: aUISection [
	"Retrieve individual elements of the UIsection objects"
	^ aUISection instVarNamed: aSymbol. 
"	^ aUISection pages first retrievePresenter "
]

{ #category : #'button action' }
InqInquisitorWorkbenchPresenter >> selectedCapturePointDo: aBlock ifNilDo: anotherBlock [
	"If a capture point is selected in the capturePoints section, execute @aBlock with it as argument. Otherwise, execute @anotherBlock"
	capturePointsNotebook selectedPage activePresenter selectedCapturePoint ifNil: [anotherBlock value] ifNotNil: [:cp | aBlock cull: cp]
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> setItemsOfInquisitorDropList: anOrderedCollection [
	"Change the inquisitor list shown in inquisitorDropList. If the new inquisitor list is empty, instead put a list containing an empty inquisitor in order to prevent inquisitorDropList from being empty."
	[self uiIsMuted: true.
	anOrderedCollection isEmpty ifFalse: [inquisitorDropList items: anOrderedCollection] ifTrue: [ inquisitorDropList items: (OrderedCollection new add: InqEmptyInquisitor new; yourself) ]] ensure: [ self uiIsMuted: false ].
	"inquisitorDropList selectIndex: 1."
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> setItemsOfQuestionDropList: anOrderedCollection [
	"Change the question list shown in questionDropList. If the new question list is empty, instead put a list containing an empty question in order to prevent questionDropList from being empty"
	[self uiIsMuted: true.
	anOrderedCollection isEmpty ifFalse: [questionDropList items: anOrderedCollection] ifTrue: [ questionDropList items: (OrderedCollection new add: InqEmptyQuestion new; yourself) ].] ensure: [ self uiIsMuted: false ].
	questionDropList selectIndex: 1.
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> setModelBeforeInitialization: anObject [
	"This method is called before the initialisation methods (like #initializePresenters), when this presenter instance is created by sending #on: to its class. It is typically used to fill the instance variables of this presenter instance before the initilisation methods get called.
	@anObject is the argument provided to the #on: call. It typically contains all the values to be put into the instance variables"
	
	"instanceVariable1 := anObject getValueForInstanceVariable1"
]

{ #category : #accessing }
InqInquisitorWorkbenchPresenter >> uiIsMuted [
	"If true, indicates that the text fields should not #whenTextChangedDo: and dropList should not whenSelectionChangedDo: . Used to disable UI reactions when the UI modifies itself (changing text in text fields, selecting items in droplist) and we do not want these modifications to trigger more reactions.
	It is muted by default so that it is muted during its own initialisation"
	uiIsMuted ifNil: [ uiIsMuted := true ].
	^ uiIsMuted
]

{ #category : #accessing }
InqInquisitorWorkbenchPresenter >> uiIsMuted: aBoolean [
	"See comment of #uiIsMuted"
	uiIsMuted := aBoolean
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> whenInquisitorIsSelected: anInquisitor [
	anInquisitor ifNil: [ ^ self ].
	self uiIsMuted: true.
	self setItemsOfQuestionDropList: anInquisitor questionHistory.
	setupCodeField text: anInquisitor setupCode.
	setupCodeField editable: (anInquisitor isEmptyInquisitor not).
	executionCodeField text: anInquisitor executionCode.
	executionCodeField editable: (anInquisitor isEmptyInquisitor not).
	removeInquisitorButton enabled: (anInquisitor isEmptyInquisitor not).
	setMainInquisitorButton enabled: ((anInquisitor isEmptyInquisitor not) and: [InqInquisitor mainInstance ~= anInquisitor]).
	self uiIsMuted: false
	
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> whenQuestionIsSelected: anInqInquisitorQuestion [
	| selectedQuestion |
	selectedQuestion := anInqInquisitorQuestion.
	selectedQuestion ifNil: [ selectedQuestion := InqEmptyQuestion new ].
	questionQuickViewTable items: selectedQuestion quickView.
	capturePointsNotebook removeAll.
	capturePointsPagesDictionary := nil.
	InqCapturePointsAbstractPresenter allSubclassesDo: [ :cpPresenterClass | 
		(cpPresenterClass canHandle: selectedQuestion) ifTrue: [ 
			capturePointsNotebook addPageTitle: (cpPresenterClass pageName) provider: [ 
				self capturePointsPagesDictionary at: cpPresenterClass 	ifAbsentPut: [
					cpPresenterClass on: selectedQuestion
				]
			]
		]	
	].
	"Bind the collection of capturePoints to the 'capturePointsCollection' variable in the capture points playground"
	(capturePointsPlayground bindingOf: 'capturePointsCollection') ifNotNil: [:binding | binding value: anInqInquisitorQuestion capturePoints]. "The ifNotNil is because at some point in the initialisation, this method gets called and capturePointsPlayground is a StPlayground (no idea why, as it should be a SpCodePresenter), and #bindingOf: returns nil."
	capturePointsNotebook selectPageIndex: 1.
]

{ #category : #initialization }
InqInquisitorWorkbenchPresenter >> windowIsClosing [
	super windowIsClosing.
	InqInquisitor instanceLogAnnouncer unsubscribe: self.
	InqInquisitor instances do: [ :inq | inq updateAnnouncer unsubscribe: self ].
]
