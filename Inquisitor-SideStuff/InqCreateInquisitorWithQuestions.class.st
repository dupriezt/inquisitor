Class {
	#name : #InqCreateInquisitorWithQuestions,
	#superclass : #Object,
	#category : #'Inquisitor-SideStuff'
}

{ #category : #operations }
InqCreateInquisitorWithQuestions class >> create [
	<script>
	| inq hitCheckTargetNode |
	inq := InqInquisitorForTest newForTestMethodName: #testDummyFull onTestClass: InqInquisitorTestDummy.
	inq isSilent: true.
	hitCheckTargetNode := self findFlagNode: 'targetNode' inMethod: (InqInquisitorTestDummy>>#testDummyFull).
	inq askQuestion: (InqHitCheckQuestion newForNode: hitCheckTargetNode).
	
	inq askQuestion: (InqMethodReturnQuestion newForMethod: (InqPointDummy>>#sum)).
	inq isSilent: false.
	
]

{ #category : #operations }
InqCreateInquisitorWithQuestions class >> createOnCode [
	<script>
	| inq |
	inq := InqInquisitor newForCode: 'someCode' withSetupCode: 'someSetupCode'.
	inq isSilent: true.
	inq isSilent: false.
	
	
]

{ #category : #operations }
InqCreateInquisitorWithQuestions class >> findFlagNode: aString inMethod: aCompiledMethod [
	^ ((aCompiledMethod) ast allChildren select: [ :node | node isMessage and: [ node selector = #flag: and: [ node arguments first value = aString ] ] ]) first.
	
	
]
