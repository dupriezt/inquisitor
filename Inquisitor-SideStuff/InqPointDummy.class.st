Class {
	#name : #InqPointDummy,
	#superclass : #Object,
	#instVars : [
		'x',
		'y'
	],
	#category : #'Inquisitor-SideStuff'
}

{ #category : #'instance creation' }
InqPointDummy class >> x: anInt y: anInt2 [
	^ self new x: anInt; y: anInt2; yourself
]

{ #category : #accessing }
InqPointDummy >> sum [
	^ x + y
]

{ #category : #accessing }
InqPointDummy >> x: aValue [
	x := aValue
]

{ #category : #accessing }
InqPointDummy >> y: aValue [
	y := aValue
]
