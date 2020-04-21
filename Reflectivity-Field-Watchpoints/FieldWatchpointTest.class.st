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
FieldWatchpointTest >> allNodes [
	^ OrderedCollection new
		addAll: self allNodesForV1;
		addAll: self allNodesForV2;
		yourself
]

{ #category : #helpers }
FieldWatchpointTest >> allNodesForV1 [
	^ OrderedCollection new
		addAll: self nodesForV1InFieldWatchpointMockClass;
		addAll: self nodesForV1InFieldWatchpointMockSubclass;
		yourself
]

{ #category : #helpers }
FieldWatchpointTest >> allNodesForV2 [
	^ OrderedCollection new
		addAll: self nodesForV2InFieldWatchpointMockSubclass;
		yourself
]

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
	nodes add: (FieldWatchpointMockSubclass>>#v2) ast statements first value.
	nodes add: (FieldWatchpointMockSubclass>>#v2:) ast statements first.
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
FieldWatchpointTest >> testAllSlotNamesFor [
	self
		assertCollection: (FieldWatchpoint allSlotNamesFor: FieldWatchpointMockSubclass)
		equals: (OrderedCollection with: #v1 with: #v2)
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

{ #category : #tests }
FieldWatchpointTest >> testNewWatchPointForVariableInClass [
	wp := FieldWatchpoint newWatchPointForVariable: #var inClass: #class.
	self assert: wp class identicalTo: FieldWatchpoint.
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #var).
	self assert: wp targetClass equals: #class
]

{ #category : #tests }
FieldWatchpointTest >> testNewWatchPointInClass [
	wp := FieldWatchpoint newWatchPointInClass: FieldWatchpointMockSubclass.
	self assert: wp class identicalTo: FieldWatchpoint.
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClass equals: FieldWatchpointMockSubclass
]

{ #category : #tests }
FieldWatchpointTest >> testRemove [

	wp := FieldWatchpoint watchVariablesIn: FieldWatchpointMockSubclass.
	wp remove.
	
	self denyCollection: Breakpoint all includesAll: (OrderedCollection with: wp).	
	self assertEmpty: wp link nodes.
	self assertEmpty: (self allNodes asIdentitySet flatCollect:[:n| n links]).
	
	self shouldnt: [FieldWatchpointMockClass new] raise: Break.
	self shouldnt: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	self shouldnt: [FieldWatchpointMockSubclass new ] raise: Break.
	self shouldnt: [obj2 instVarReads] raise: Break.
	self shouldnt: [obj2 instVarWrites] raise: Break.
	self shouldnt: [obj2 v2] raise: Break.	
	self shouldnt: [obj2 v2: 0] raise: Break.
	self shouldnt: [obj2 v1] raise: Break.	
	self shouldnt: [obj2 v1: 0] raise: Break.
	
]

{ #category : #tests }
FieldWatchpointTest >> testScopeTo [
	| instance testContext |
	instance := Object new.
	testContext := Context newForMethod: FieldWatchpointMockClass >> #v1.
	wp := FieldWatchpoint new.
	wp scopeTo: instance.
	self assert: wp targetInstance identicalTo: instance.
	self assert: wp link hasCondition.
	self assertCollection: wp link conditionArguments equals: #(context).
	self
		assert: (wp link condition value: (testContext receiver: instance)).
	self
		deny: (wp link condition value: (testContext receiver: Object new))
]

{ #category : #tests }
FieldWatchpointTest >> testWatchVariableIn [ 	

	wp := FieldWatchpoint watchVariable: #v1 in: FieldWatchpointMockClass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1).
	self assert: wp targetClass identicalTo: FieldWatchpointMockClass.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: Breakpoint all includesAll: (OrderedCollection with: wp).	
	self assertCollection: wp link nodes asIdentitySet equals: self allNodesForV1 asIdentitySet.
	
	self should: [FieldWatchpointMockClass new] raise: Break.
	self should: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.
	self should: [ FieldWatchpointMockSubclass new ] raise: Break.
	self should: [ obj2 instVarReads] raise: Break.
	self should: [ obj2 instVarWrites] raise: Break
	
	
]

{ #category : #tests }
FieldWatchpointTest >> testWatchVariableReadsIn [ 	

	wp := FieldWatchpoint watchVariableReads: #v1 in: FieldWatchpointMockClass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1).
	self assert: wp targetClass identicalTo: FieldWatchpointMockClass.
	self assert: wp targetInstance equals: nil.
	self assert: wp accessStrategy equals: #read.
	
	self assertCollection: Breakpoint all includesAll: (OrderedCollection with: wp).	
	self assertCollection: wp link nodes asIdentitySet 
			equals: (self allNodesForV1 select:[:n| n isVariable]) asIdentitySet.
	
	self shouldnt: [FieldWatchpointMockClass new] raise: Break.
	self should: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	self shouldnt: [ FieldWatchpointMockSubclass new ] raise: Break.
	self should: [ obj2 instVarReads] raise: Break.
	self shouldnt: [ obj2 instVarWrites] raise: Break
	
	
]

{ #category : #tests }
FieldWatchpointTest >> testWatchVariableWritesIn [ 	

	wp := FieldWatchpoint watchVariableWrites: #v1 in: FieldWatchpointMockClass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1).
	self assert: wp targetClass identicalTo: FieldWatchpointMockClass.
	self assert: wp targetInstance equals: nil.
	self assert: wp accessStrategy equals: #write.
	
	self assertCollection: Breakpoint all includesAll: (OrderedCollection with: wp).	
	self assertCollection: wp link nodes asIdentitySet 
			equals: (self allNodesForV1 select:[:n| n isAssignment]) asIdentitySet.
	
	self should: [FieldWatchpointMockClass new] raise: Break.
	self shouldnt: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.
	self should: [ FieldWatchpointMockSubclass new ] raise: Break.
	self shouldnt: [ obj2 instVarReads] raise: Break.
	self should: [ obj2 instVarWrites] raise: Break
	
	
	
	
]

{ #category : #tests }
FieldWatchpointTest >> testWatchVariablesIn [	

	wp := FieldWatchpoint watchVariablesIn: FieldWatchpointMockSubclass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClass identicalTo: FieldWatchpointMockSubclass.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: Breakpoint all includesAll: (OrderedCollection with: wp).	
	self assertCollection: wp link nodes asIdentitySet equals: self allNodes asIdentitySet.
	
	self should: [FieldWatchpointMockClass new] raise: Break.
	self should: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.
	self should: [FieldWatchpointMockSubclass new ] raise: Break.
	self should: [obj2 instVarReads] raise: Break.
	self should: [obj2 instVarWrites] raise: Break.
	self should: [obj2 v2] raise: Break.	
	self should: [obj2 v2: 0] raise: Break.
	self should: [obj2 v1] raise: Break.	
	self should: [obj2 v1: 0] raise: Break.
	
]

{ #category : #tests }
FieldWatchpointTest >> testWatchVariablesReadsIn [	

	wp := FieldWatchpoint watchVariablesReadsIn: FieldWatchpointMockSubclass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClass identicalTo: FieldWatchpointMockSubclass.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: Breakpoint all includesAll: (OrderedCollection with: wp).	
	self assertCollection: wp link nodes asIdentitySet 
			equals: (self allNodes select:[:n| n isVariable]) asIdentitySet.
	
	self shouldnt: [FieldWatchpointMockClass new] raise: Break.
	self should: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	self shouldnt: [FieldWatchpointMockSubclass new ] raise: Break.
	self should: [obj2 instVarReads] raise: Break.
	self shouldnt: [obj2 instVarWrites] raise: Break.
	self should: [obj2 v2] raise: Break.	
	self shouldnt: [obj2 v2: 0] raise: Break.
	self should: [obj2 v1] raise: Break.	
	self shouldnt: [obj2 v1: 0] raise: Break.
	
]

{ #category : #tests }
FieldWatchpointTest >> testWatchVariablesWritesIn [	

	wp := FieldWatchpoint watchVariablesWritesIn: FieldWatchpointMockSubclass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClass identicalTo: FieldWatchpointMockSubclass.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: Breakpoint all includesAll: (OrderedCollection with: wp).	
	self assertCollection: wp link nodes asIdentitySet 
			equals: (self allNodes select:[:n| n isAssignment]) asIdentitySet.
	
	self should: [FieldWatchpointMockClass new] raise: Break.
	self shouldnt: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.
	self should: [FieldWatchpointMockSubclass new ] raise: Break.
	self shouldnt: [obj2 instVarReads] raise: Break.
	self should: [obj2 instVarWrites] raise: Break.
	self shouldnt: [obj2 v2] raise: Break.	
	self should: [obj2 v2: 0] raise: Break.
	self shouldnt: [obj2 v1] raise: Break.	
	self should: [obj2 v1: 0] raise: Break.
	
]
