Class {
	#name : #InquisitorTest,
	#superclass : #TestCase,
	#category : #Inquisitor
}

{ #category : #tests }
InquisitorTest >> testDummy [
	1+1.
	Point new.
	self inform: 'testDummy was ran'.
	self assert: true.
]
