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
	^ self new testMethodName: aSymbol; testClass: aClass; yourself
	
]

{ #category : #accessing }
InqInquisitorForTest >> asStringForClyCommand [
	^ 'Inquisitor on test: ', self testMethodFullName
]

{ #category : #utility }
InqInquisitorForTest >> runExecution [
	super runExecution.
"	| testInstance |
	testInstance := testClass new.
	testInstance setUp.
	self runExecutionBlock: [ testInstance perform: testMethodName ]"
]

{ #category : #accessing }
InqInquisitorForTest >> testClass: aClass [
	testClass := aClass.
	self setupCode: '	testInstance := ',aClass name,' new.
	testInstance setUp.'
]

{ #category : #accessing }
InqInquisitorForTest >> testMethodFullName [
	^ testClass asString, '>>#', testMethodName asString
]

{ #category : #accessing }
InqInquisitorForTest >> testMethodName: aSymbol [
	"example of @aSymbol: #new"
	testMethodName := aSymbol.
	self executionCode: 'testInstance perform: #', aSymbol.
]
