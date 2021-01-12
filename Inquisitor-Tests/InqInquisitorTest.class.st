Class {
	#name : #InqInquisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'inquisitor',
		'inquisitedMethod',
		'breakpoints',
		'assistClassesInitialStateDictionary'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #running }
InqInquisitorTest >> assertAssistClassesHaveSameMethodsAsInitially [
	"Assert that the assist classes have the same methods (at least in terms of selectors) that they had during the setUp. Checks for both instance side and class side methods."
	| assistClass initialStateDictionary |
	assistClassesInitialStateDictionary associationsDo: [ :assoc |
		assistClass := assoc key.
		initialStateDictionary := assoc value.
		self assert: (initialStateDictionary at: #instanceSideSelectors) equals: (assistClass methods collect: [:meth | meth selector]).
		self assert: (initialStateDictionary at: #classSideSelectors) equals: (assistClass class methods collect: [:meth | meth selector]).		
	]
]

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

{ #category : #'as yet unclassified' }
InqInquisitorTest >> assertNoBreakpointsInMethodsOfAssistClasses [
	"Asserts that there are no breakpoints in the methods of the assist classes"
	"Instance side methods"
	(self assistClasses flatCollect: [:assistClass | assistClass methods]) do: [ :meth | self assert: meth hasBreakpoint not ].
	"Class side methods"
	(self assistClasses flatCollect: [:assistClass | assistClass class methods]) do: [ :meth | self assert: meth hasBreakpoint not ].
]

{ #category : #tests }
InqInquisitorTest >> assistClasses [
	"Classes used by this test class in its test"
	^ {  }
]

{ #category : #running }
InqInquisitorTest >> captureInitialStateOfAssistClass: assistClass inDictionary: d [
	d at: #instanceSideSelectors put: (assistClass methods collect: [ :meth | meth selector ]).
	d at: #classSideSelectors put: (assistClass class methods collect: [ :meth | meth selector ])
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

{ #category : #'as yet unclassified' }
InqInquisitorTest >> postTestAssertions [
	"Common assertions to be checked after each test run"
	self assertAssistClassesHaveSameMethodsAsInitially.
	self assertNoBreakpointsInMethodsOfAssistClasses.
]

{ #category : #running }
InqInquisitorTest >> removeBreakpoints [
	breakpoints do: [ :brkpt | brkpt remove ].
	breakpoints := OrderedCollection new.
]

{ #category : #running }
InqInquisitorTest >> setUp [
	super setUp.
	breakpoints := OrderedCollection new.
	"Empties the instance registers of the assist classes"
	self assistClasses do: [ :assistClass | assistClass clearInstances ].
	"Capture initial state of assist classes, so that it can be asserted later that they were not modified by the tests"
	assistClassesInitialStateDictionary := Dictionary new.
	self assistClasses do: [ :assistClass | |d|
		d := Dictionary new.
		assistClassesInitialStateDictionary at: assistClass put: d.
		self captureInitialStateOfAssistClass: assistClass inDictionary: d
	].
]

{ #category : #running }
InqInquisitorTest >> setUpForInquisitedCode: aString withSetupCode: anotherString [	
	inquisitor := InqInquisitor newWithoutRegisteringInstanceForCode: aString withSetupCode: anotherString.
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
	breakpointsToRemove do: [ :brkpt | brkpt remove ].
	self assistClasses do: [ :assistClass | assistClass clearInstances ]
]

{ #category : #tests }
InqInquisitorTest >> testCreateInquisitorOnCustomCodeAndRunExecution [
	"Test that creating an inquisitor on a custom execution and running it works"
	self setUpForInquisitedCode: 'Point x: 1 y: var' withSetupCode: 'var := 2'.
	inquisitor runExecution.
	
	self postTestAssertions
]

{ #category : #tests }
InqInquisitorTest >> testCreateInquisitorOnTestAndRunExecution [
	"Test that creating an inquisitor on a test and running it works"
	self setUpForInquisitedMethod: (self class)>>#testDummy.
	inquisitor runExecution.
	
	self postTestAssertions
]

{ #category : #tests }
InqInquisitorTest >> testDummy [
	"Do nothing. Used by other tests"
	Point new
]

{ #category : #tests }
InqInquisitorTest >> testExceptionRaisedByExecutionShouldStopQuestionAndAppearAsTermination [
	| q |
	self setUpForInquisitedCode: 'InqInquisitorTestAssistClass new callDoNothingWithError' withSetupCode: ''.
	q := InqHitCheckQuestion newForNode: ((InqInquisitorTestAssistClass>>#doNothingWithError) ast body statements first). "Point new"
	inquisitor askQuestion: q.
	self assert: q capturePoints size equals: 1. "Checks that the execution of the question was stopped at the first error. Otherwise, the inquisited node would have been reached more than one time"
	self assert: q executionTermination isNormalTermination not.
	
	self postTestAssertions
]

{ #category : #tests }
InqInquisitorTest >> testHaltInCodeShouldBeIgnored [
	| q |
	self setUpForInquisitedCode: 'InqInquisitorTestAssistClass new doNothingWithHalt' withSetupCode: ''.
	q := InqHitCheckQuestion newForNode: ((InqInquisitorTestAssistClass>>#doNothingWithHalt) ast body statements first). "Point new"
	self shouldnt: [inquisitor askQuestion: q] raise: Halt.
	self assertExecutionTerminationNormal: q.
	self assert: q capturePoints size equals: 1.
	
	self postTestAssertions
]

{ #category : #tests }
InqInquisitorTest >> testSetupCodeShouldNotProduceCapturePoints [
	"Test that when asking a question to an inquisitor, no capture points are created when the setup code is executed."
	| q |
	self setUpForInquisitedCode: 'InqInquisitorTestAssistClass new doNothing' withSetupCode: 'InqInquisitorTestAssistClass new doNothing'.
	q := InqHitCheckQuestion newForNode: ((InqInquisitorTestAssistClass>>#doNothing) ast body statements first). "Point new"
	inquisitor askQuestion: q.
	self assertExecutionTerminationNormal: q.
	self assert: q capturePoints size equals: 1.
	
	self postTestAssertions
]
