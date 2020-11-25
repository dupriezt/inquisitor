Class {
	#name : #MethodReturnQuestionTest,
	#superclass : #InquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #tests }
MethodReturnQuestionTest >> assistClass [
	^ InquisitorTestMethodReturnDummy
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnFalse [
	(self assistClass) new returnFalse.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnImplicitSelf [
	(self assistClass) new returnImplicitSelf.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnInBlock [
	(self assistClass) new returnInBlock.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnNil [
	(self assistClass) new returnNil.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnNonSpecialCase [.
	(self assistClass) new nonSpecialReturn.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnSelf [
	(self assistClass) new returnSelf.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnTrue [
	(self assistClass) new returnTrue.
]

{ #category : #running }
MethodReturnQuestionTest >> setUp [
	super setUp.
	self assistClass clearInstances.
]

{ #category : #tests }
MethodReturnQuestionTest >> tearDown [
	self assistClass clearInstances.
	super tearDown
]

{ #category : #tests }
MethodReturnQuestionTest >> testImplicitReturnSelf [
	| question capturePoints questionedMethod receiverInstance |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnImplicitSelf.
	
	questionedMethod := (self assistClass)>>#returnImplicitSelf.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	receiverInstance := (self assistClass) instances at: 1.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: capturePoints first capturedValue equals: receiverInstance.
	self assert: capturePoints first breakpointsEncountered size equals: 1.
	self assert: capturePoints first methodInvocation invokedMethod name equals: questionedMethod name. "The compiled methods are different because one contains bytecode for the breakpoint that was inserted into it"
	
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnFalse [
	| question capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnFalse.
	questionedMethod := (self assistClass)>>#returnFalse.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: false receiver: inst method: questionedMethod  nbBreakpoints: 1
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnInBlock [
	| question capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnInBlock.
	questionedMethod := (self assistClass)>>#returnInBlock.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: 42 receiver: inst method: questionedMethod nbBreakpoints: 1
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnNil [
	| question capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnNil.
	questionedMethod := (self assistClass)>>#returnNil.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: nil receiver: inst method: questionedMethod nbBreakpoints: 1
	
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnNonSpecialCase [
	| question capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnNonSpecialCase.
	questionedMethod := (self assistClass)>>#nonSpecialReturn.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: 42 receiver: inst method: questionedMethod nbBreakpoints: 1
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnSelf [
	| question capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnSelf.
	questionedMethod := (self assistClass)>>#returnSelf.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: inst receiver: inst method: questionedMethod nbBreakpoints: 1.
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnTrue [
	| question capturePoints questionedMethod inst |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnTrue.
	questionedMethod := (self assistClass)>>#returnTrue.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: self assistClass instances size equals: 1.
	inst := self assistClass instances first.
	self assertCapturePoint: (capturePoints first) value: true receiver: inst method: questionedMethod nbBreakpoints: 1
	
]
