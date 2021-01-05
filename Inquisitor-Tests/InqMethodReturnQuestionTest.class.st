Class {
	#name : #InqMethodReturnQuestionTest,
	#superclass : #InqInquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #tests }
InqMethodReturnQuestionTest >> assistClass [
	^ InqInquisitorTestMethodReturnDummy
]

{ #category : #tests }
InqMethodReturnQuestionTest >> dummyForTestReturnFalse [
	(self assistClass) new returnFalse.
]

{ #category : #tests }
InqMethodReturnQuestionTest >> dummyForTestReturnImplicitSelf [
	(self assistClass) new returnImplicitSelf.
]

{ #category : #tests }
InqMethodReturnQuestionTest >> dummyForTestReturnInBlock [
	(self assistClass) new returnInBlock.
]

{ #category : #tests }
InqMethodReturnQuestionTest >> dummyForTestReturnNil [
	(self assistClass) new returnNil.
]

{ #category : #tests }
InqMethodReturnQuestionTest >> dummyForTestReturnNonSpecialCase [.
	(self assistClass) new nonSpecialReturn.
]

{ #category : #tests }
InqMethodReturnQuestionTest >> dummyForTestReturnSelf [
	(self assistClass) new returnSelf.
]

{ #category : #tests }
InqMethodReturnQuestionTest >> dummyForTestReturnTrue [
	(self assistClass) new returnTrue.
]

{ #category : #running }
InqMethodReturnQuestionTest >> setUp [
	super setUp.
	self assistClass clearInstances.
]

{ #category : #tests }
InqMethodReturnQuestionTest >> tearDown [
	self assistClass clearInstances.
	super tearDown
]

{ #category : #tests }
InqMethodReturnQuestionTest >> testImplicitReturnSelf [
	"This test is expected to fail at the moment, because the feature of capturing implicit returns has not yet been implemented"
	| q capturePoints questionedMethod receiverInstance |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnImplicitSelf.
	
	questionedMethod := (self assistClass)>>#returnImplicitSelf.
	q := InqMethodReturnQuestion newForMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	receiverInstance := (self assistClass) instances at: 1.
	capturePoints := q capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: capturePoints first capturedValue equals: receiverInstance.
	self assert: capturePoints first breakpointsEncountered size equals: 1.
	self assert: capturePoints first methodInvocation invokedMethod name equals: questionedMethod name. "The compiled methods are different because one contains bytecode for the breakpoint that was inserted into it"
	
]

{ #category : #tests }
InqMethodReturnQuestionTest >> testReturnFalse [
	| q capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnFalse.
	questionedMethod := (self assistClass)>>#returnFalse.
	q := InqMethodReturnQuestion newForMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	capturePoints := q capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: false receiver: inst method: questionedMethod  nbBreakpoints: 1
]

{ #category : #tests }
InqMethodReturnQuestionTest >> testReturnInBlock [
	| q capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnInBlock.
	questionedMethod := (self assistClass)>>#returnInBlock.
	q := InqMethodReturnQuestion newForMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	capturePoints := q capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: 42 receiver: inst method: questionedMethod nbBreakpoints: 1
]

{ #category : #tests }
InqMethodReturnQuestionTest >> testReturnNil [
	| q capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnNil.
	questionedMethod := (self assistClass)>>#returnNil.
	q := InqMethodReturnQuestion newForMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	capturePoints := q capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: nil receiver: inst method: questionedMethod nbBreakpoints: 1
	
]

{ #category : #tests }
InqMethodReturnQuestionTest >> testReturnNonSpecialCase [
	| q capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnNonSpecialCase.
	questionedMethod := (self assistClass)>>#nonSpecialReturn.
	q := InqMethodReturnQuestion newForMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	capturePoints := q capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: 42 receiver: inst method: questionedMethod nbBreakpoints: 1
]

{ #category : #tests }
InqMethodReturnQuestionTest >> testReturnSelf [
	| q capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnSelf.
	questionedMethod := (self assistClass)>>#returnSelf.
	q := InqMethodReturnQuestion newForMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	capturePoints := q capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: inst receiver: inst method: questionedMethod nbBreakpoints: 1.
]

{ #category : #tests }
InqMethodReturnQuestionTest >> testReturnTrue [
	| q capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnTrue.
	questionedMethod := (self assistClass)>>#returnTrue.
	q := InqMethodReturnQuestion newForMethod: questionedMethod.
	q askToInquisitor: inquisitor.
	self assertExecutionTerminationNormal: q.
	capturePoints := q capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: true receiver: inst method: questionedMethod nbBreakpoints: 1
	
]
