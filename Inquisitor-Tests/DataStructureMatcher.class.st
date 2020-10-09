"
Use method match: aDataStructure toPattern: aPattern.
Tries to match aDataStructure on the structure described by aPattern. Returns a dictionary mapping the symbols used in aPattern to the values occupying their spot in aDataStructure. Can also signal a DataStructureMatchError if aDatastructure does not have the same structure as aPattern

Warning, for dictionaries, the keys will be sorted before getting matched with symbols from aPattern. So make sure you write aPattern taking this into account

Datastructure: nested dictionaries/array like collections
Example of data structure:
	ds := Dictionary new.
	subDictionary := Dictionary new at: #kd put: 5; at: #ke put: 6; yourself.
	ds at: #ka put: (OrderedCollection new add: 1; add: 2; yourself).
	ds at: #kb put: 42.
	ds at: #kc put: subDictionary.
	
Pattern:
Example of pattern:
	pt := {
		#k -> { #a. #b }.
		#l -> #c.
		#m -> { #n -> #d. #o -> #e }
	}.
	
Usage example:
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
"
Class {
	#name : #DataStructureMatcher,
	#superclass : #Object,
	#category : #'Inquisitor-Tests'
}

{ #category : #'as yet unclassified' }
DataStructureMatcher >> dsmError: aString [
	DataStructureMatchError signal: aString
]

{ #category : #'as yet unclassified' }
DataStructureMatcher >> match: aDataStructure toArrayPattern: aPattern [
	| assignment subAssignments |
	aDataStructure isString ifTrue: [ self dsmError: 'Expected aDataStructure not to be a string' ].
	aDataStructure isCollection ifFalse: [ self dsmError: 'aDataStructure is not a collection' ].
	aDataStructure isSequenceable ifFalse: [ self dsmError: 'aDataStructure is not sequenceable' ].
	(aDataStructure size = aPattern size) ifFalse: [ self dsmError: 'aDataStructure is sequenceable but does not have as many elements as aPattern' ].
	assignment := Dictionary new.
	subAssignments := OrderedCollection new.
	aPattern withIndexDo: [ :ptElem :index |
		subAssignments add: (self match: (aDataStructure at: index) toPattern: ptElem)
	].
	subAssignments do: [ :subAssngmt | assignment addAll: subAssngmt ].
	^ assignment
]

{ #category : #'as yet unclassified' }
DataStructureMatcher >> match: aDataStructure toDictionaryPattern: aPattern [
	| dicoKeys assignment subAssignments |
	aDataStructure isDictionary ifFalse: [ self dsmError: 'aDataStructure is not a dictionary' ].
	dicoKeys := aDataStructure keys sorted.
	(dicoKeys size = aPattern size) ifFalse: [ self dsmError: 'aDataStructure is a dictionary but does not have as many keys as aPattern' ].
	assignment := Dictionary new.
	subAssignments := OrderedCollection new.
	aPattern withIndexDo: [ :pAssoc :index |
		|dicoKey|
		dicoKey := dicoKeys at: index.
		assignment at: (pAssoc key) put: dicoKey.
		subAssignments add: (self match: (aDataStructure at: dicoKey) toPattern: (pAssoc value))
	].
	subAssignments do: [ :subAssngmt | assignment addAll: subAssngmt ].
	^ assignment
	
]

{ #category : #'as yet unclassified' }
DataStructureMatcher >> match: aDataStructure toPattern: aPattern [
	(self patternIsDictionary: aPattern) ifTrue: [ ^ self match: aDataStructure toDictionaryPattern: aPattern ].
	(self patternIsArray: aPattern) ifTrue: [ ^ self match: aDataStructure toArrayPattern: aPattern ].
	"aPattern is a single value"
	^ self match: aDataStructure toSingleValuePattern: aPattern.
]

{ #category : #'as yet unclassified' }
DataStructureMatcher >> match: aDataStructure toSingleValuePattern: aPattern [
	| assignment |
	assignment := Dictionary new.
	assignment at: aPattern put: aDataStructure.
	^ assignment
]

{ #category : #'as yet unclassified' }
DataStructureMatcher >> patternIsArray: aPattern [
	aPattern isString ifTrue: [ ^ false ].
	^ aPattern isSequenceable
]

{ #category : #'as yet unclassified' }
DataStructureMatcher >> patternIsDictionary: aPattern [
	aPattern isCollection ifFalse: [ ^ false ].
	^ aPattern allSatisfy: [ :elem | elem isAssociation ].
]
