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
InqClassInstanciationQuestion >> askToInquisitor: anInquisitor [
	"Answer the question, using anInquisitor to run the execution. No need to return anything, fill your capturePoints variable with the capture points constituting the answer to the question."
	"Create an empty collection where the proxy methods can put the information they gather on the instanciations"
	instanciationData := OrderedCollection new.
	"Add self to the @hashToQuestionDictionary class variable, so that the proxy methods can find self to report information about instance creation"
	self class hashToQuestionDictionary at: (self hash) put: self.
	self proxyInstanceCreationMethodsOnClass: targetClass.
	[self runExecutionWithInquisitor: anInquisitor] ensure: [ self unInstallProxyMethods].
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> indexesOfInstanceCreationPrimitives [
	"* 70 */ primitiveNew,
	/* 71 */ primitiveNewWithArg,
	/* 79 */ primitiveNewMethod,
	/* 148 */ primitiveClone,
	/* 160 */ primitiveAdoptInstance,"
	^#(70 71 79 148 160)
]

{ #category : #accessing }
InqClassInstanciationQuestion >> instanciationData [
	^ instanciationData
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> methodsToProxyOnClassSideOfClass: aClass [
	"Returns the list of all class side methods of @aClass that should be proxied to capture all attempts to instanciate it"
	^ (aClass class allMethods select: [ :meth | self indexesOfInstanceCreationPrimitives includes: meth primitive ]) asOrderedCollection.
]

{ #category : #'as yet unclassified' }
InqClassInstanciationQuestion >> methodsToProxyOnInstanceSideOf: aClass [
	"Returns the list of all instance side methods of @aClass that should be proxied to capture all attempts to instanciate it"
	^ (aClass allMethods select: [ :meth | self indexesOfInstanceCreationPrimitives includes: meth primitive ]) asOrderedCollection
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
	self proxyMethods: nil.
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
