Class {
	#name : #InqClassInstanciationQuestion,
	#superclass : #InqInquisitorQuestion,
	#instVars : [
		'proxyMethods',
		'targetClass',
		'instanciationData'
	],
	#classVars : [
		'hashToQuestionDictionary'
	],
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion class >> hashToQuestionDictionary [
	hashToQuestionDictionary ifNil: [ hashToQuestionDictionary := Dictionary new ].
	^ hashToQuestionDictionary
]

{ #category : #'instance creation' }
InqClassInstanciationQuestion class >> newForClass: aClass [
	^ self new targetClass: aClass; yourself
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion class >> resetHashToQuestionDictionary [
	hashToQuestionDictionary := nil.
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> askToInquisitor: anInquisitor [
	"Answer the question, using anInquisitor to run the execution. No need to return anything, fill your capturePoints variable with the capture points constituting the answer to the question."
	"Create an empty collection where the proxy methods can put the information they gather on the instanciations"
	instanciationData := OrderedCollection new.
	"Add self to the @hashToQuestionDictionary class variable, so that the proxy methods can find self to report information about instance creation"
	self class hashToQuestionDictionary at: (self hash) put: self.
	[self proxyInstanceCreationMethodsOnClass: targetClass.
	self runExecutionWithInquisitor: anInquisitor.] ensure: [
		self unInstallProxyMethods.
		self class hashToQuestionDictionary removeKey: (self hash). "Remove self from the @hashToQuestionDictionary class variable"
	].
	self processInstanciationDataIntoCapturePoints.
]

{ #category : #accessing }
InqClassInstanciationQuestion >> createBreakpointForNode: aNode andClassCondition: aClass [
	"Assumes @aNode is a message node. Create a breakpoint on @aNode, with the condition that the receiver of the message must be @aClass, or an instance of @aClass"
	^ Breakpoint new node: aNode; condition: [ :ctx |
		|msgReceiver|
		"We look at the parent of the currentNode, because the currentNode is the send of the #break message inserted by this breakpoint's installation"
		msgReceiver := ctx at: (ctx basicSize - ctx currentNode parent arguments size).
		(msgReceiver == aClass) or: [msgReceiver class == aClass].
	]; yourself.
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> indexesOfClassBasedInstanceCreationPrimitives [
	"Indexes of primitives that are on classes and create an instance of that class"
	"* 70 */ primitiveNew,
	/* 71 */ primitiveNewWithArg,
	/* 79 */ primitiveNewMethod,
	/* 160 */ primitiveAdoptInstance,"
	^#(70 71 79 160)
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> indexesOfInstanceBasedInstanceCreationPrimitives [
	"Indexes of primitives that are on instances of a class and create an instance of that class"
	"/* 148 */ primitiveClone,"
	^#(148)
]

{ #category : #accessing }
InqClassInstanciationQuestion >> instanciationData [
	"Format: an OrderedCollection of arrays of the form:
	- AST node calling the instance creation primitive
	- Instance created
	- Hash of the context containing the call to the instance creation primitive
	- Method of the context ...
	- Receiver of the context ...
	"
	^ instanciationData
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> methodsToProxyOnClassSideOfClass: aClass [
	"Returns the list of all class side methods of @aClass that should be proxied to capture all attempts to instanciate it"
	^ (aClass class allMethods select: [ :meth | self indexesOfClassBasedInstanceCreationPrimitives includes: meth primitive ]) asOrderedCollection.
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> methodsToProxyOnInstanceSideOf: aClass [
	"Returns the list of all instance side methods of @aClass that should be proxied to capture all attempts to instanciate it"
	^ (aClass allMethods select: [ :meth | self indexesOfInstanceBasedInstanceCreationPrimitives includes: meth primitive ]) asOrderedCollection
]

{ #category : #accessing }
InqClassInstanciationQuestion >> processInstanciationDataIntoCapturePoints [
	"Process the information about instance creation contained in @instanciationData and make capture points out of it"
	| nodeToBreakpointDict |
	"To avoid creating multiple breakpoints for the same AST node"
	nodeToBreakpointDict := Dictionary new.
	instanciationData do: [ :instanceCreationData | |callNode instance contextHash method receiver methodInvocation breakpoint capturePoint|
		callNode := instanceCreationData at: 1.
		instance := instanceCreationData at: 2.
		contextHash := instanceCreationData at: 3.
		method := instanceCreationData at: 4.
		receiver := instanceCreationData at: 5.
		methodInvocation := InqMethodInvocation newForContextHash: contextHash andContextMethod: method.
		breakpoint := nodeToBreakpointDict at: callNode ifAbsentPut: [ self createBreakpointForNode: callNode andClassCondition: targetClass ].
		self breakpointsEncountered add: breakpoint.
		capturePoint := self capturePointFactory newCapturePointForReceiver: receiver andMethodInvocation: methodInvocation andCapturedValue: instance andBreakpointsEncountered: self breakpointsEncountered copy.
		self flag: 'Remove following line when capture points created by this question can be opened without danger'.
		capturePoint isOpenable: false.
		self capturePoints add: capturePoint.
	]
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> proxyInstanceCreationMethodsOnClass: aClass [
	| methodsToProxyOnClassSide methodsToProxyOnInstanceSide methodsToProxy |
"	methodsToProxyOnClassSide := self methodsToProxyOnClassSideOfClass: aClass.
	methodsToProxyOnInstanceSide := self methodsToProxyOnInstanceSideOf: aClass."
	methodsToProxy := (self methodsToProxyOnClassSideOfClass: aClass) addAll: (self methodsToProxyOnInstanceSideOf: aClass); yourself.
	self proxyMethods addAll: (methodsToProxy collect: [ :meth | InqProxyMethodForClassInstanciation newForTargetMethod: meth andTargetClass: aClass andClassInstanciationQuestionHash: self hash ]).
	self proxyMethods do: [ :proxyMethod | proxyMethod install ].
"	self proxyMethods addAll: (methodsToProxyOnInstanceSide collect: [:meth | (InqProxyMethod newToProxyMethod: meth onClass: aClass) install; yourself]).
	""The proxy methods on the class side have to be installed on aClass' class""
	self proxyMethods addAll: (methodsToProxyOnClassSide collect: [:meth | (InqProxyMethod newToProxyMethod: meth onClass: aClass class) install; yourself])."
]

{ #category : #accessing }
InqClassInstanciationQuestion >> proxyMethods [
	proxyMethods ifNil: [ proxyMethods := OrderedCollection new].
	^ proxyMethods
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> proxyMethods: anOrderedCollection [
	proxyMethods := anOrderedCollection
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> resultDescription [
	"Returns a string describing the result of this question"
	self flag: 'TODO'.
	^ 'Class Instanciation result'
]

{ #category : #accessing }
InqClassInstanciationQuestion >> targetClass [
	^ targetClass
]

{ #category : #accessing }
InqClassInstanciationQuestion >> targetClass: aClass [
	targetClass := aClass
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> unInstallProxyMethods [
	self proxyMethods do: [ :proxyMethod | proxyMethod unInstall ].
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> whenBreakpoint: aBreakpoint isHitForBreakException: aBreakException [
	"This method will be called whenever the inquisited execution encounters a breakpoint present in the @breakpoints variable of this object (the list of breakpoints this question has installed)"
	self error: 'No breakpoint should be hit when runing this question, because it does not set any'
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> whenInqQuestionException: anInqQuestionException [
	"This method will be called whenever the inquisited execution signals an InqQuestionException exception."
	| contextThatCalledTheInstanciationMethod callerNode|
	contextThatCalledTheInstanciationMethod := anInqQuestionException signalerContext sender.
	callerNode := contextThatCalledTheInstanciationMethod currentNode.
	self breakpointsEncountered add: (Breakpoint new node: callerNode; always; yourself).
	self capturePoints add: (self capturePointFactory newCapturePointForContext: contextThatCalledTheInstanciationMethod andCapturedValue: nil andBreakpointsEncountered: self breakpointsEncountered)
]
