Class {
	#name : #DataStructureMatcherTest,
	#superclass : #TestCase,
	#instVars : [
		'dsm'
	],
	#category : #'Inquisitor-Tests'
}

{ #category : #running }
DataStructureMatcherTest >> setUp [
	super setUp.
	
	dsm := DataStructureMatcher new.
]

{ #category : #running }
DataStructureMatcherTest >> testMatchArray [
	| ds pt res |
	ds := OrderedCollection new. "datastructure"
	ds add: 1; add: 2; add: 3.
	pt := { #a. #b. #c }. "pattern"
	dsm := DataStructureMatcher new.
	res := dsm match: ds toPattern: pt.
	self assert: res size equals: 3.
	self assert: (res at: #a) equals: 1.
	self assert: (res at: #b) equals: 2.
	self assert: (res at: #c) equals: 3.
]

{ #category : #running }
DataStructureMatcherTest >> testMatchDictionary [
	| ds pt res |
	ds := Dictionary new. "datastructure"
	ds at: $a put: 42; at: $b put: 43.
	pt := { #a -> #b. #c -> #d }. "pattern"
	dsm := DataStructureMatcher new.
	res := dsm match: ds toPattern: pt.
	self assert: res size equals: 4.
	self assert: (res at: #a) equals: $a.
	self assert: (res at: #b) equals: 42.
	self assert: (res at: #c) equals: $b.
	self assert: (res at: #d) equals: 43.
]

{ #category : #running }
DataStructureMatcherTest >> testMatchNestedDataStructure [
	| ds pt res subDictionary |
	ds := Dictionary new. "datastructure"
	subDictionary := Dictionary new at: #kd put: 5; at: #ke put: 6; yourself.
	ds at: #ka put: (OrderedCollection new add: 1; add: 2; yourself).
	ds at: #kb put: 42.
	ds at: #kc put: subDictionary.
	pt := {
		#k -> { #a. #b }.
		#l -> #c.
		#m -> { #n -> #d. #o -> #e }
	}. "pattern"
	dsm := DataStructureMatcher new.
	res := dsm match: ds toPattern: pt.
	self assert: res size equals: 10.
	self assert: (res at: #k) equals: #ka.
	self assert: (res at: #l) equals: #kb.
	self assert: (res at: #m) equals: #kc.
	self assert: (res at: #a) equals: 1.
	self assert: (res at: #b) equals: 2.
	self assert: (res at: #c) equals: 42.
	self assert: (res at: #n) equals: #kd.
	self assert: (res at: #o) equals: #ke.
	self assert: (res at: #d) equals: 5.
	self assert: (res at: #e) equals: 6.
]

{ #category : #running }
DataStructureMatcherTest >> testMatchSingleValue [
	| ds pt res |
	ds := 5. "datastructure"
	pt := #a. "pattern"
	dsm := DataStructureMatcher new.
	res := dsm match: ds toPattern: pt.
	self assert: res size equals: 1.
	self assert: (res at: #a) equals: 5.
]

{ #category : #running }
DataStructureMatcherTest >> testPatternIsArray [
	self assert: (dsm patternIsArray: { #a -> #b. #c -> #d }) not.
	self assert: (dsm patternIsArray: {#a. #b}).
	self assert: (dsm patternIsArray: #a) not.
]

{ #category : #running }
DataStructureMatcherTest >> testPatternIsDictionary [
	self assert: (dsm patternIsDictionary: { #a -> #b. #c -> #d }).
	self assert: (dsm patternIsDictionary: {#a. #b}) not.
	self assert: (dsm patternIsDictionary: #a) not.
]
