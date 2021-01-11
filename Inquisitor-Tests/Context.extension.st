Extension { #name : #Context }

{ #category : #'*Inquisitor-Tests' }
Context >> currentNode [
	^ self method sourceNodeForPC: self pc
]
