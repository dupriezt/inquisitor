Class {
	#name : #BreakpointAnnouncementListener,
	#superclass : #Object,
	#category : #'Inquisitor-SideStuff'
}

{ #category : #accessing }
BreakpointAnnouncementListener class >> eventBreakpointAdded: aBreakpointAdded [
	self inform: 'Brkpt added'
]

{ #category : #accessing }
BreakpointAnnouncementListener class >> eventBreakpointHit: aBreakpointHit [
	self inform: 'Brkpt hit'
]

{ #category : #accessing }
BreakpointAnnouncementListener class >> eventBreakpointRemoved: aBreakpointRemoved [
	self inform: 'Brkpt removed'
]

{ #category : #accessing }
BreakpointAnnouncementListener class >> turnOff [
	<script>
	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : #accessing }
BreakpointAnnouncementListener class >> turnOn [
	<script>
	SystemAnnouncer uniqueInstance when: BreakpointAdded send: #eventBreakpointAdded: to: self.
	SystemAnnouncer uniqueInstance when: BreakpointHit send: #eventBreakpointHit: to: self.
	SystemAnnouncer uniqueInstance when: BreakpointRemoved send: #eventBreakpointRemoved: to: self.
]
