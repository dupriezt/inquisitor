Class {
	#name : #BaselineOfInquisitor,
	#superclass : #BaselineOf,
	#category : #BaselineOfInquisitor
}

{ #category : #baselines }
BaselineOfInquisitor >> baseline: spec [
	<baseline>
	spec for: #common do: [
		"Dependency on another baseline"
		spec baseline: 'Sindarin' with: [spec repository: 'github://dupriezt/ScriptableDebugger'].
		spec package: 'Inquisitor'.
		spec package: 'Inquisitor-Tests'
	].
]
