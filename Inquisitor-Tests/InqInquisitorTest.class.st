Class {
	#name : #InqInquisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'inquisitor',
		'inquisitedMethod',
		'breakpoints'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #running }
InqInquisitorTest >> assertCapturePoint: aCapturePoint value: aValue receiver: anObject method: aCompiledMethod nbBreakpoints: anInteger [
	self assert: aCapturePoint capturedValue equals: aValue.
	self assert: aCapturePoint receiver equals: anObject.
	"Checking equality on the names of the methods; and not on the methods themselves, because the compiled methods are sometimes different just because one contains bytecode for the breakpoint that was inserted into it"
	self assert: aCapturePoint methodInvocation invokedMethod name equals: aCompiledMethod name.
	self assert: aCapturePoint breakpointsEncountered size equals: anInteger
	
]

{ #category : #running }
InqInquisitorTest >> assertCollection: aCollection matchesPattern: patternCollection [
	"Asserts that @aCollection matches the pattern of @patternCollection.
	For example, collection { 1. 2. 2. 3 } matches the pattern: { #a. #b. #b. #c }.
	Both collections need to be ordered, and the elements of @patternCollection must be usable as keys in a dictionary
	"
	| patternAssignment pattern |
	patternAssignment := Dictionary new.
	self assert: aCollection size equals: patternCollection size.
	aCollection doWithIndex: [ :el :i | 
		pattern := patternCollection at: i.
		patternAssignment	at: pattern ifPresent: [:v | self assert: el equals: v ] ifAbsent: [ patternAssignment at: pattern put: el ]
	]
	
	
]

{ #category : #running }
InqInquisitorTest >> checkFormatOf: aCollection accordingTo: aTemplate [
	
	| templateIsDictionary assignment |
	"Determine if aTemplate is for a dictionary or an ordered collection."
	templateIsDictionary := nil.
	aTemplate do: [:elem | templateIsDictionary ifNil: [ templateIsDictionary := elem isAssociation] ifNotNil: [ :tmpltIsDict | (tmpltIsDict = elem isAssociation) ifTrue: [ self error: 'aTemplate contains associations and non-associations' ] ] ].
	
	assignment := Dictionary new. "Dictionary maping symbols in aTemplate to the value they represent in aCollection"
	templateIsDictionary ifTrue: [ 
		self assert: aCollection isDictionary.
		self assert: aCollection keys size equals: aTemplate size.
		
		
	] ifFalse: [
		self assert: aCollection isSequenceable.
	
	]
]

{ #category : #running }
InqInquisitorTest >> removeBreakpoints [
	breakpoints do: [ :brkpt | brkpt remove ].
	breakpoints := OrderedCollection new.
]

{ #category : #running }
InqInquisitorTest >> setUp [
	super setUp.
	inquisitor := InqInquisitor new.
	inquisitor isSilent: true.
	breakpoints := OrderedCollection new
]

{ #category : #running }
InqInquisitorTest >> setUpForInquisitedMethod: aCompiledMethod [
	inquisitedMethod := aCompiledMethod.
	inquisitor testClass: inquisitedMethod methodClass.
	inquisitor testMethodName: inquisitedMethod selector.
]

{ #category : #running }
InqInquisitorTest >> tearDown [
	self removeBreakpoints.
]
