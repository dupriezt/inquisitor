Class {
	#name : #Inquisitor,
	#superclass : #Object,
	#instVars : [
		'testMethodName',
		'testClass',
		'questionHistory'
	],
	#classVars : [
		'mainInstance'
	],
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
Inquisitor class >> askQuestion: anInquisitorQuestion [
	self mainInstance ifNil: [ self error: 'Undefined main instance of Inquisitor' ] ifNotNil: [ :mnInst | mnInst askQuestion: anInquisitorQuestion ]
]

{ #category : #'as yet unclassified' }
Inquisitor class >> mainInstance [
	^ mainInstance
]

{ #category : #'as yet unclassified' }
Inquisitor class >> mainInstance: anInstance [
	mainInstance := anInstance
]

{ #category : #'question management' }
Inquisitor >> addResolvedQuestion: anInquisitorQuestion [
	self inform: anInquisitorQuestion resultDescription.
	self questionHistory add: anInquisitorQuestion.
]

{ #category : #'question management' }
Inquisitor >> askQuestion: anInquisitorQuestion [
	anInquisitorQuestion askToInquisitor: self
]

{ #category : #accessing }
Inquisitor >> questionHistory [
	questionHistory ifNil: [ questionHistory := OrderedCollection new ].
	^ questionHistory 
]

{ #category : #utility }
Inquisitor >> runExecution [
	| testInstance |
	testInstance := testClass new.
	testInstance setUp.
	testInstance perform: testMethodName
]

{ #category : #accessing }
Inquisitor >> testClass [
	^ testClass
]

{ #category : #accessing }
Inquisitor >> testClass: anObject [
	testClass := anObject
]

{ #category : #accessing }
Inquisitor >> testMethodName [
	^ testMethodName
]

{ #category : #accessing }
Inquisitor >> testMethodName: anObject [
	testMethodName := anObject
]
