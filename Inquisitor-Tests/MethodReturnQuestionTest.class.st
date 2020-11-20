Class {
	#name : #MethodReturnQuestionTest,
	#superclass : #InquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnFalse [
	InquisitorTestMethodReturnDummy new returnFalse.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnImplicitSelf [
	InquisitorTestMethodReturnDummy new returnImplicitSelf.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnInBlock [
	InquisitorTestMethodReturnDummy new returnInBlock.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnNil [
	InquisitorTestMethodReturnDummy new returnNil.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnNonSpecialCase [.
	InquisitorTestMethodReturnDummy new nonSpecialReturn.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnSelf [
	InquisitorTestMethodReturnDummy new returnSelf.
]

{ #category : #tests }
MethodReturnQuestionTest >> dummyForTestReturnTrue [
	InquisitorTestMethodReturnDummy new returnTrue.
]

{ #category : #tests }
MethodReturnQuestionTest >> testImplicitReturnSelf [
	| question answer receiverInstance |
	self setUpForInquisitedMethod: MethodReturnQuestionTest>>#dummyForTestReturnImplicitSelf.
	
	question := MethodReturnQuestion newForMethod: InquisitorTestMethodReturnDummy>>#returnImplicitSelf.
	question askToInquisitor: inquisitor.
	answer := (inquisitor questionHistory last at: #a).
	receiverInstance := InquisitorTestMethodReturnDummy instances at: 1.
	self assert: (answer at: #returnValue) equals: receiverInstance.
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnFalse [
	| question answer |
	self setUpForInquisitedMethod: MethodReturnQuestionTest>>#dummyForTestReturnFalse.
	
	question := MethodReturnQuestion newForMethod: InquisitorTestMethodReturnDummy>>#returnFalse.
	question askToInquisitor: inquisitor.
	answer := (inquisitor questionHistory last at: #a).
	self assert: (answer at: #returnValue) equals: false.
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnInBlock [
	| question answer receiverInstance |
	self setUpForInquisitedMethod: MethodReturnQuestionTest>>#dummyForTestReturnInBlock.
	
	question := MethodReturnQuestion newForMethod: InquisitorTestMethodReturnDummy>>#returnInBlock.
	question askToInquisitor: inquisitor.
	answer := (inquisitor questionHistory last at: #a).
	receiverInstance := InquisitorTestMethodReturnDummy instances at: 1.
	self assert: (answer at: #returnValue) equals: 42.
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnNil [
	| question answer receiverInstance |
	self setUpForInquisitedMethod: MethodReturnQuestionTest>>#dummyForTestReturnNil.
	
	question := MethodReturnQuestion newForMethod: InquisitorTestMethodReturnDummy>>#returnNil.
	question askToInquisitor: inquisitor.
	answer := (inquisitor questionHistory last at: #a).
	receiverInstance := InquisitorTestMethodReturnDummy instances at: 1.
	self assert: (answer at: #returnValue) equals: nil.
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnNonSpecialCase [
	| question capturePoints questionedMethod |
	self setUpForInquisitedMethod: MethodReturnQuestionTest>>#dummyForTestReturnNonSpecialCase.
	
	questionedMethod := InquisitorTestMethodReturnDummy>>#nonSpecialReturn.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: capturePoints first capturedValue equals: 42.
	self assert: capturePoints first breakpointsEncountered size equals: 1.
	self assert: capturePoints first methodInvocation invokedMethod name equals: questionedMethod name. "The compiled methods are different because one contains bytecode for the breakpoint that was inserted into it"
	
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnSelf [
	| question answer receiverInstance |
	self setUpForInquisitedMethod: MethodReturnQuestionTest>>#dummyForTestReturnSelf.
	
	question := MethodReturnQuestion newForMethod: InquisitorTestMethodReturnDummy>>#returnSelf.
	question askToInquisitor: inquisitor.
	answer := (inquisitor questionHistory last at: #a).
	receiverInstance := InquisitorTestMethodReturnDummy instances at: 1.
	self assert: (answer at: #returnValue) equals: receiverInstance.
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnTrue [
	| question answer receiverInstance |
	self setUpForInquisitedMethod: MethodReturnQuestionTest>>#dummyForTestReturnTrue.
	
	question := MethodReturnQuestion newForMethod: InquisitorTestMethodReturnDummy>>#returnTrue.
	question askToInquisitor: inquisitor.
	answer := (inquisitor questionHistory last at: #a).
	receiverInstance := InquisitorTestMethodReturnDummy instances at: 1.
	self assert: (answer at: #returnValue) equals: true.
]
