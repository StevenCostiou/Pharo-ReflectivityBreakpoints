Class {
	#name : #FieldWatchpointTest,
	#superclass : #TestCase,
	#instVars : [
		'obj1',
		'obj2',
		'wp'
	],
	#category : #'Reflectivity-Field-Watchpoints'
}

{ #category : #helpers }
FieldWatchpointTest >> nodesForV1InFieldWatchpointMockClass [
	|nodes |
	nodes := OrderedCollection new.
	nodes add: (FieldWatchpointMockClass>>#initialize) ast statements first.
	nodes add: (FieldWatchpointMockClass>>#v1) ast statements first value.
	nodes add: (FieldWatchpointMockClass>>#v1:) ast statements first.
	^nodes
]

{ #category : #helpers }
FieldWatchpointTest >> nodesForV1InFieldWatchpointMockSubclass [
	|nodes |
	nodes := OrderedCollection new.
	nodes add: (FieldWatchpointMockSubclass>>#instVarWrites) ast statements first.
	nodes add: (FieldWatchpointMockSubclass>>#instVarReads) ast statements first value receiver.
	^nodes
]

{ #category : #helpers }
FieldWatchpointTest >> nodesForV2InFieldWatchpointMockSubclass [
	|nodes |
	nodes := OrderedCollection new.
	nodes add: (FieldWatchpointMockSubclass>>#initialize) ast statements second.
	nodes add: (FieldWatchpointMockSubclass>>#instVarReads) ast statements first value arguments first.
	nodes add: (FieldWatchpointMockSubclass>>#instVarWrites) ast statements second.
	nodes add: (FieldWatchpointMockClass>>#v2) ast statements first value.
	nodes add: (FieldWatchpointMockClass>>#v2:) ast statements first.
	^nodes
]

{ #category : #running }
FieldWatchpointTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	obj1 := FieldWatchpointMockClass new.
	obj2 := FieldWatchpointMockSubclass new
]

{ #category : #running }
FieldWatchpointTest >> tearDown [
	wp
		ifNotNil: [ wp isInstalled
				ifTrue: [ wp remove ] ].
	super tearDown
]

{ #category : #tests }
FieldWatchpointTest >> testInitialize [ 	
	wp := FieldWatchpoint new.
	self assert: wp accessStrategy equals: #all.
	self assertEmpty: wp targetVariableNames.
	self deny: wp isInstalled
]

{ #category : #tests }
FieldWatchpointTest >> testIsWatchpoint [
	self assert: FieldWatchpoint new isWatchpoint.
	self deny: Breakpoint new isWatchpoint
]
