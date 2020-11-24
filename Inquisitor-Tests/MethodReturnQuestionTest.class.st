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
	| question capturePoints questionedMethod receiverInstance |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnImplicitSelf.
	
	questionedMethod := InquisitorTestMethodReturnDummy>>#returnImplicitSelf.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	receiverInstance := InquisitorTestMethodReturnDummy instances at: 1.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: capturePoints first capturedValue equals: receiverInstance.
	self assert: capturePoints first breakpointsEncountered size equals: 1.
	self assert: capturePoints first methodInvocation invokedMethod name equals: questionedMethod name. "The compiled methods are different because one contains bytecode for the breakpoint that was inserted into it"
	
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnFalse [
	| question capturePoints questionedMethod |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnFalse.
	
	questionedMethod := InquisitorTestMethodReturnDummy>>#returnFalse.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: capturePoints first capturedValue equals: false.
	self assert: capturePoints first breakpointsEncountered size equals: 1.
	self assert: capturePoints first methodInvocation invokedMethod name equals: questionedMethod name. "The compiled methods are different because one contains bytecode for the breakpoint that was inserted into it"
	
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnInBlock [
	| question capturePoints questionedMethod |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnInBlock.
	
	questionedMethod := InquisitorTestMethodReturnDummy>>#returnInBlock.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: capturePoints first capturedValue equals: 42.
	self assert: capturePoints first breakpointsEncountered size equals: 1.
	self assert: capturePoints first methodInvocation invokedMethod name equals: questionedMethod name. "The compiled methods are different because one contains bytecode for the breakpoint that was inserted into it"
	
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnNil [
	| question capturePoints questionedMethod |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnNil.
	
	questionedMethod := InquisitorTestMethodReturnDummy>>#returnNil.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: capturePoints first capturedValue equals: nil.
	self assert: capturePoints first breakpointsEncountered size equals: 1.
	self assert: capturePoints first methodInvocation invokedMethod name equals: questionedMethod name. "The compiled methods are different because one contains bytecode for the breakpoint that was inserted into it"
	
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnNonSpecialCase [
	| question capturePoints questionedMethod |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnNonSpecialCase.
	
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
	| question capturePoints questionedMethod receiverInstance |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnSelf.
	
	questionedMethod := InquisitorTestMethodReturnDummy>>#returnSelf.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	receiverInstance := InquisitorTestMethodReturnDummy instances at: 1.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: capturePoints first capturedValue equals: receiverInstance.
	self assert: capturePoints first breakpointsEncountered size equals: 1.
	self assert: capturePoints first methodInvocation invokedMethod name equals: questionedMethod name. "The compiled methods are different because one contains bytecode for the breakpoint that was inserted into it"
	
]

{ #category : #tests }
MethodReturnQuestionTest >> testReturnTrue [
	| question capturePoints questionedMethod |
	self setUpForInquisitedMethod: (self class)>>#dummyForTestReturnTrue.
	
	questionedMethod := InquisitorTestMethodReturnDummy>>#returnTrue.
	question := MethodReturnQuestion newForMethod: questionedMethod.
	question askToInquisitor: inquisitor.
	capturePoints := question capturePoints.
	self assert: capturePoints size equals: 1.
	self assert: capturePoints first capturedValue equals: true.
	self assert: capturePoints first breakpointsEncountered size equals: 1.
	self assert: capturePoints first methodInvocation invokedMethod name equals: questionedMethod name. "The compiled methods are different because one contains bytecode for the breakpoint that was inserted into it"
	
]
