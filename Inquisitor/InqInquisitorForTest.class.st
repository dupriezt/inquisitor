"
I am a subclass of InqInquisitor to use when the code to inquisite is a test
"
Class {
	#name : #InqInquisitorForTest,
	#superclass : #InqInquisitor,
	#instVars : [
		'testMethodName',
		'testClass'
	],
	#category : #Inquisitor
}

{ #category : #'instance creation' }
InqInquisitorForTest class >> newForTestMethodName: aSymbol onTestClass: aClass [
	| result |
	result := self new.
	result testMethodName: aSymbol; testClass: aClass.
	^ result
	
]

{ #category : #accessing }
InqInquisitorForTest >> asStringForClyCommand [
	^ 'Inquisitor on test: ', self testMethodFullName
]

{ #category : #utility }
InqInquisitorForTest >> runExecution [
	| testInstance |
	testInstance := testClass new.
	testInstance setUp.
	self runExecutionBlock: [ testInstance perform: testMethodName ]
]

{ #category : #accessing }
InqInquisitorForTest >> testClass: anObject [
	testClass := anObject
]

{ #category : #accessing }
InqInquisitorForTest >> testMethodFullName [
	^ testClass asString, '>>#', testMethodName asString
]

{ #category : #accessing }
InqInquisitorForTest >> testMethodName: anObject [
	testMethodName := anObject
]
