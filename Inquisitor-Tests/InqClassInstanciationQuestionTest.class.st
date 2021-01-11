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
InqClassInstanciationQuestionTest >> testDummy [ 
	self assert: true
]

{ #category : #tests }
InqClassInstanciationQuestionTest >> testRunOnSimpleClass [

	| q |
	self setUpForInquisitedMethod: self class>>#createTestInstances.
	
	q := InqClassInstanciationQuestion newForClass: InqTestAssistClassForClassInstanciation.
	q askToInquisitor: inquisitor.
	self assert: q capturePoints size equals: 2.
	q inspect.
	self postTestAssertions
]
