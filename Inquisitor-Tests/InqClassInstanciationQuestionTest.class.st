Class {
	#name : #InqClassInstanciationQuestionTest,
	#superclass : #InqInquisitorTest,
	#category : #'Inquisitor-Tests'
}

{ #category : #tests }
InqClassInstanciationQuestionTest >> assistClasses [
	^ { InqTestAssistClassForClassInstanciation }
]

{ #category : #tests }
InqClassInstanciationQuestionTest >> createTestInstances [
	"Dummy code for tests"
	InqTestAssistClassForClassInstanciation new.
	Point new.
	InqTestAssistClassForClassInstanciation basicNew. 
]

{ #category : #tests }
InqClassInstanciationQuestionTest >> testRunOnSimpleClass [
	| q firstCP secondCP |
	self flag: 'Incomplete test. No time'.
	
	self setUpForInquisitedMethod: self class>>#createTestInstances.
	
	q := InqClassInstanciationQuestion newForClass: InqTestAssistClassForClassInstanciation.
	q askToInquisitor: inquisitor.
	self assert: q capturePoints size equals: 2.
"	q inspect."
	firstCP := q capturePoints first.
	self assert: firstCP methodInvocation invokedMethod name equals: 'Behavior>>#new'.
	secondCP := q capturePoints second.
	self assert: secondCP methodInvocation invokedMethod name equals: 'InqClassInstanciationQuestionTest>>#createTestInstances'.
	
	self postTestAssertions
]
