Class {
	#name : #InqTimeStampedContext,
	#superclass : #Object,
	#instVars : [
		'methodName',
		'pc'
	],
	#category : #Inquisitor
}

{ #category : #'as yet unclassified' }
InqTimeStampedContext >> compareTo: aTimeStampedContext ifDifferentMethodName: diffMethodNameBlock ifSmallerPC: smallerPCBlock ifSamePC: samePCBlock ifGreaterPC: greaterPCBlock [
	"Compares self and @aTimeStampedContext in terms of age (who was created first during the execution). Also works if they come from different executions with the same code."
	(aTimeStampedContext methodName ~= self methodName) ifTrue: [ ^ diffMethodNameBlock value ].
	"If this point is reached the method names are the same"
	((self pc) < (aTimeStampedContext pc)) ifTrue: [ ^ smallerPCBlock value ].
	((self pc) > (aTimeStampedContext pc)) ifTrue: [ ^ greaterPCBlock value ].
	^ samePCBlock value
	

]

{ #category : #accessing }
InqTimeStampedContext >> methodName [

	^ methodName
]

{ #category : #accessing }
InqTimeStampedContext >> methodName: anObject [

	methodName := anObject
]

{ #category : #accessing }
InqTimeStampedContext >> pc [

	^ pc
]

{ #category : #accessing }
InqTimeStampedContext >> pc: anObject [

	pc := anObject
]

{ #category : #printing }
InqTimeStampedContext >> printOn: aStream [
	aStream
		nextPutAll: '(';
	 	nextPutAll: self pc asString;
		nextPutAll: ', ';
		nextPutAll: self methodName asString;
		nextPutAll: ') '.
	super printOn: aStream
]
