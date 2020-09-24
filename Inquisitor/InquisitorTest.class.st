Class {
	#name : #InquisitorTest,
	#superclass : #TestCase,
	#category : #Inquisitor
}

{ #category : #tests }
InquisitorTest >> testDummy [
	| i |
	i := 0.
	1+1.
	Point new.
	[ i = 3 ] whileFalse: [ i := i + 1 ].
	self inform: 'testDummy was ran'.
	self assert: true.
]
