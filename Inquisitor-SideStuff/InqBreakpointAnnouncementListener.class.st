Class {
	#name : #InqBreakpointAnnouncementListener,
	#superclass : #Object,
	#category : #'Inquisitor-SideStuff'
}

{ #category : #accessing }
InqBreakpointAnnouncementListener class >> eventBreakpointAdded: aBreakpointAdded [
	self inform: 'Brkpt added'
]

{ #category : #accessing }
InqBreakpointAnnouncementListener class >> eventBreakpointHit: aBreakpointHit [
	self inform: 'Brkpt hit'
]

{ #category : #accessing }
InqBreakpointAnnouncementListener class >> eventBreakpointRemoved: aBreakpointRemoved [
	self inform: 'Brkpt removed'
]

{ #category : #accessing }
InqBreakpointAnnouncementListener class >> turnOff [
	<script>
	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : #accessing }
InqBreakpointAnnouncementListener class >> turnOn [
	<script>
	SystemAnnouncer uniqueInstance when: BreakpointAdded send: #eventBreakpointAdded: to: self.
	SystemAnnouncer uniqueInstance when: BreakpointHit send: #eventBreakpointHit: to: self.
	SystemAnnouncer uniqueInstance when: BreakpointRemoved send: #eventBreakpointRemoved: to: self.
]
