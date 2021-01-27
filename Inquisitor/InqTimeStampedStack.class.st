"
- methodCalls: OrderedCollection<Dictionary<#methodName->String, #pc->Integer>>
First element is the oldest context of the stack (the context that started the execution), last element is the youngest context of the stack (the last method that was called, the one which is currently executing)
- context: Context
"
Class {
	#name : #InqTimeStampedStack,
	#superclass : #Object,
	#instVars : [
		'context',
		'methodCalls'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqTimeStampedStack class >> newForContext: aContext [
	^ self new beForContext: aContext; yourself.
]

{ #category : #'as yet unclassified' }
InqTimeStampedStack >> beForContext: aContext [
	| currentContext |
	context := aContext.
	self methodCalls addAll: (aContext stack collect: [:ctx | InqTimeStampedContext new methodName: (ctx method name); pc: (ctx pc); yourself ]).
	
	"currentContext := context.
	[currentContext isNotNil] whileTrue: [
		self methodCalls add: (InqTimeStampedContext new methodName: (currentContext method name); pc: (currentContext pc); yourself).
		currentContext := currentContext sender.
	]."
	methodCalls := self methodCalls reversed
	
]

{ #category : #'as yet unclassified' }
InqTimeStampedStack >> comesBefore: aTimeStampedStack [
	|i mySize itsSize |
	i := 1.
	mySize := self methodCalls size.
	itsSize := aTimeStampedStack methodCalls size.
	[ true ] whileTrue: [ |myTStampContext itsTStampedContext|
		(i > mySize) ifTrue: [ 
			(i > itsSize) ifTrue: [ 
				"Both stacks have the same size, and their contexts were all equal"
				^ true
			] ifFalse: [ 
				"My stack and its stack have the same start, but my stack is shorter"
				^ true
			]
		].
		myTStampContext := self methodCalls at: i.
		itsTStampedContext := aTimeStampedStack methodCalls at: i.
		myTStampContext compareTo: itsTStampedContext
			ifDifferentMethodName: [ self error: 'Unexpected case: different method names' ]
			ifSmallerPC: [ ^ true ]
			ifSamePC: [ "do nothing, keep running the algorithm" ]
			ifGreaterPC: [ ^ false ].
		i := i + 1.
	]
]

{ #category : #'as yet unclassified' }
InqTimeStampedStack >> methodCalls [
	methodCalls ifNil: [ methodCalls := OrderedCollection new ].
	^ methodCalls
]
