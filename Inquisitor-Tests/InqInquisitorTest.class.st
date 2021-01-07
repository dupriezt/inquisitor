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

{ #category : #asserting }
InqInquisitorTest >> assertExecutionTerminationNormal: anInqInquisitorQuestion [
	self assert: anInqInquisitorQuestion executionTermination isNormalTermination
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
	inquisitor := InqInquisitorForTest newWithoutRegisteringInstance.
	inquisitor isSilent: true.
	breakpoints := OrderedCollection new
]

{ #category : #running }
InqInquisitorTest >> setUpForInquisitedCode: aString withSetupCode: anotherString [	
	inquisitor := InqInquisitor newForCode: aString withSetupCode: anotherString.
	inquisitor isSilent: true.
]

{ #category : #running }
InqInquisitorTest >> setUpForInquisitedMethod: aCompiledMethod [
	inquisitor := InqInquisitorForTest newWithoutRegisteringInstance.
	inquisitor isSilent: true.
	inquisitedMethod := aCompiledMethod.
	inquisitor testClass: inquisitedMethod methodClass.
	inquisitor testMethodName: inquisitedMethod selector.
]

{ #category : #running }
InqInquisitorTest >> tearDown [
	| methodsToClean breakpointsToRemove |
	self removeBreakpoints.
	"Remove breakpoints from the following methods"
	methodsToClean := { InqInquisitorTestAssistClass>>#doNothingWithHalt }.
	breakpointsToRemove := Breakpoint all select: [ :brkpt | (brkpt link methods) includesAny: methodsToClean].
	breakpointsToRemove do: [ :brkpt | brkpt remove ]
]

{ #category : #tests }
InqInquisitorTest >> testCreateInquisitorOnCustomCodeAndRunExecution [
	"Test that creating an inquisitor on a custom execution and running it works"
	| inq |
	inq := InqInquisitor newForCode: 'Point x: 1 y: var' withSetupCode: 'var := 2'.
	inq runExecution.
]

{ #category : #tests }
InqInquisitorTest >> testCreateInquisitorOnTestAndRunExecution [
	"Test that creating an inquisitor on a test and running it works"
	| inq |
	inq := InqInquisitorForTest newForTestMethodName: #testDummy onTestClass: self class.
	inq runExecution.
]

{ #category : #tests }
InqInquisitorTest >> testDummy [
	"Do nothing. Used by other tests"
	Point new
]

{ #category : #tests }
InqInquisitorTest >> testExceptionRaisedByExecutionShouldStopQuestionAndAppearAsTermination [
	| inq q |
	inq := (InqInquisitor newWithoutRegisteringInstanceForCode: 'InqInquisitorTestAssistClass new callDoNothingWithError' withSetupCode: '') isSilent: true; yourself.
	q := InqHitCheckQuestion newForNode: ((InqInquisitorTestAssistClass>>#doNothingWithError) ast body statements first). "Point new"
	inq askQuestion: q.
	self assert: q capturePoints size equals: 1. "Checks that the execution of the question was stopped at the first error. Otherwise, the inquisited node would have been reached more than one time"
	self assert: q executionTermination isNormalTermination not.
]

{ #category : #tests }
InqInquisitorTest >> testHaltInCodeShouldBeIgnored [
	| inq q |
	inq := (InqInquisitor newWithoutRegisteringInstanceForCode: 'InqInquisitorTestAssistClass new doNothingWithHalt' withSetupCode: '') isSilent: true; yourself.
	q := InqHitCheckQuestion newForNode: ((InqInquisitorTestAssistClass>>#doNothingWithHalt) ast body statements first). "Point new"
	self shouldnt: [inq askQuestion: q] raise: Halt.
	self assertExecutionTerminationNormal: q.
	self assert: q capturePoints size equals: 1.
]

{ #category : #tests }
InqInquisitorTest >> testSetupCodeShouldNotProduceCapturePoints [
	"Test that when asking a question to an inquisitor, no capture points are created when the setup code is executed."
	| inq q |
	inq := (InqInquisitor newWithoutRegisteringInstanceForCode: 'InqInquisitorTestAssistClass new doNothing' withSetupCode: 'InqInquisitorTestAssistClass new doNothing') isSilent: true; yourself.
	q := InqHitCheckQuestion newForNode: ((InqInquisitorTestAssistClass>>#doNothing) ast body statements first). "Point new"
	inq askQuestion: q.
	self assertExecutionTerminationNormal: q.
	self assert: q capturePoints size equals: 1.
]
