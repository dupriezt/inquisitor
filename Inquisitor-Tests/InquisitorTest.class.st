Class {
	#name : #InquisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'inquisitor',
		'inquisitedMethod',
		'breakpoints'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #running }
InquisitorTest >> checkFormatOf: aCollection accordingTo: aTemplate [
	
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
InquisitorTest >> removeBreakpoints [
	breakpoints do: [ :brkpt | brkpt remove ].
	breakpoints := OrderedCollection new.
]

{ #category : #running }
InquisitorTest >> setUp [
	super setUp.
	inquisitor := Inquisitor new.
	inquisitor isSilent: true.
	InquisitorTestVariableDummy clearInstances.
	breakpoints := OrderedCollection new
]

{ #category : #running }
InquisitorTest >> setUpForInquisitedMethod: aCompiledMethod [
	inquisitedMethod := aCompiledMethod.
	inquisitor testClass: inquisitedMethod methodClass.
	inquisitor testMethodName: inquisitedMethod selector.
]

{ #category : #running }
InquisitorTest >> tearDown [
	InquisitorTestVariableDummy clearInstances.
	InquisitorTestMethodReturnDummy clearInstances.
	self removeBreakpoints.
]
