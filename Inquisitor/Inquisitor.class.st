Class {
	#name : #Inquisitor,
	#superclass : #Object,
	#instVars : [
		'testMethodName',
		'testClass'
	],
	#classVars : [
		'mainInstance'
	],
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
Inquisitor class >> mainInstance [
	^ mainInstance
]

{ #category : #'as yet unclassified' }
Inquisitor class >> mainInstance: anInstance [
	mainInstance := anInstance
]

{ #category : #'as yet unclassified' }
Inquisitor >> hitCheckOn: aRBProgramNode [
	"self inform: aRBProgramNode asString.
	self inform: testClass asString.
	self inform: testMethodName asString."
	| testInstance |
	testInstance := testClass new.
	testInstance perform: testMethodName.
	^ true
]

{ #category : #'as yet unclassified' }
Inquisitor >> testClass [
	^ testClass
]

{ #category : #'as yet unclassified' }
Inquisitor >> testClass: anObject [
	testClass := anObject
]

{ #category : #'as yet unclassified' }
Inquisitor >> testMethodName [
	^ testMethodName
]

{ #category : #'as yet unclassified' }
Inquisitor >> testMethodName: anObject [
	testMethodName := anObject
]
