Class {
	#name : #ClyCreateInquisitor,
	#superclass : #ClyInquisitorSourceCodeAndMethodCommand,
	#category : #Inquisitor
}

{ #category : #testing }
ClyCreateInquisitor class >> canBeExecutedInContext: aToolContext [
	^ aToolContext selectedMethods ifNotEmpty: [:array | (array at: 1) isTestMethod  ]
]

{ #category : #activation }
ClyCreateInquisitor class >> contextMenuOrder [
	^85
]

{ #category : #accessing }
ClyCreateInquisitor >> defaultMenuIconName [
	^#add
]

{ #category : #accessing }
ClyCreateInquisitor >> defaultMenuItemName [
	^'Create Inquisitor on this test method'
]

{ #category : #accessing }
ClyCreateInquisitor >> execute [
	| i |
	i := InqInquisitorForTest newForTestMethodName: method selector onTestClass: method methodClass.
	InqInquisitor mainInstance: i.
	i inspect
]
