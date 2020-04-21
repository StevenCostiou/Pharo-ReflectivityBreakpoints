Class {
	#name : #FieldWatchpointTest,
	#superclass : #TestCase,
	#instVars : [
		'obj1',
		'obj2',
		'wp',
		'obj3',
		'obj4'
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
	obj2 := FieldWatchpointMockSubclass new.
	obj3 := FieldWatchpointMockClass new.
	obj4 := FieldWatchpointMockSubclass new
]

{ #category : #running }
FieldWatchpointTest >> tearDown [
	wp
		ifNotNil: [ wp isInstalled
				ifTrue: [ wp remove ] ].
	super tearDown
]

{ #category : #'tests - installation' }
FieldWatchpointTest >> testAccessStrategy [
	
	wp := FieldWatchpoint watchVariablesIn: FieldWatchpointMockClass.
	self assert: wp accessStrategy equals: #all.
	wp remove.
	
	wp := FieldWatchpoint watchVariable: #v1 in: FieldWatchpointMockClass.
	self assert: wp accessStrategy equals: #all.
	wp remove.
	
	wp := FieldWatchpoint watchVariable: #v1 inObject: obj1.
	self assert: wp accessStrategy equals: #all.
	wp remove.
	
	wp := FieldWatchpoint watchVariablesInObject: obj1.	
	self assert: wp accessStrategy equals: #all.
	wp remove.
		
	wp := FieldWatchpoint watchVariableWrites: #v1 in: FieldWatchpointMockClass.
	self assert: wp accessStrategy equals: #write.
	wp remove.
	
	wp := FieldWatchpoint watchVariablesWritesIn: FieldWatchpointMockClass.
	self assert: wp accessStrategy equals: #write.
	wp remove.
	
	wp := FieldWatchpoint watchVariablesWritesIn: FieldWatchpointMockSubclass.
	self assert: wp accessStrategy equals: #write.
	wp remove.
	
	wp := FieldWatchpoint watchVariableWrites: #v1 inObject: obj1.
	self assert: wp accessStrategy equals: #write.
	wp remove.
	
	wp := FieldWatchpoint watchVariablesReadsInObject: obj1.
	self assert: wp accessStrategy equals: #read.
	wp remove.
	
	wp := FieldWatchpoint watchVariableReads: #v1 in: FieldWatchpointMockClass.
	self assert: wp accessStrategy equals: #read.
	wp remove.
	
	wp := FieldWatchpoint watchVariableReads: #v1 inObject: obj1.
	self assert: wp accessStrategy equals: #read.
	wp remove.
	
	wp := FieldWatchpoint watchVariablesReadsInObject: obj1.
	self assert: wp accessStrategy equals: #read.
	wp remove.
	
]

{ #category : #'tests - initialization' }
FieldWatchpointTest >> testAllSlotNamesFor [
	self
		assertCollection: (FieldWatchpoint allSlotNamesFor: FieldWatchpointMockSubclass)
		equals: (OrderedCollection with: #v1 with: #v2)
]

{ #category : #'tests - initialization' }
FieldWatchpointTest >> testInitialize [ 	
	wp := FieldWatchpoint new.
	self assert: wp accessStrategy equals: #all.
	self assertEmpty: wp targetVariableNames.
	self deny: wp isInstalled
]

{ #category : #'tests - installation' }
FieldWatchpointTest >> testInstall [
	
	wp := FieldWatchpoint newWatchPointInClass: FieldWatchpointMockSubclass.	
	wp install.
	self assertCollection: Breakpoint all includesAll: (OrderedCollection with: wp)
]

{ #category : #'tests - installation' }
FieldWatchpointTest >> testIsInstalled [
	
	wp := FieldWatchpoint newWatchPointInClass: FieldWatchpointMockSubclass.
	self deny: wp isInstalled.
	wp install.
	self assert: wp isInstalled
]

{ #category : #'tests - initialization' }
FieldWatchpointTest >> testIsWatchpoint [
	self assert: FieldWatchpoint new isWatchpoint.
	self deny: Breakpoint new isWatchpoint
]

{ #category : #'tests - initialization' }
FieldWatchpointTest >> testNewWatchPointForVariableInClass [
	wp := FieldWatchpoint newWatchPointForVariable: #var inClass: #class.
	self assert: wp class identicalTo: FieldWatchpoint.
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #var).
	self assert: wp targetClass equals: #class
]

{ #category : #'tests - initialization' }
FieldWatchpointTest >> testNewWatchPointInClass [
	wp := FieldWatchpoint newWatchPointInClass: FieldWatchpointMockSubclass.
	self assert: wp class identicalTo: FieldWatchpoint.
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClass equals: FieldWatchpointMockSubclass
]

{ #category : #'tests - installation' }
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

{ #category : #'tests - installation' }
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

{ #category : #'tests - class wide watchpoints' }
FieldWatchpointTest >> testWatchVariableIn [ 	

	wp := FieldWatchpoint watchVariable: #v1 in: FieldWatchpointMockClass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1).
	self assert: wp targetClass identicalTo: FieldWatchpointMockClass.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: wp link nodes asIdentitySet equals: self allNodesForV1 asIdentitySet.
	
	self should: [FieldWatchpointMockClass new] raise: Break.
	self should: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.
	self should: [ FieldWatchpointMockSubclass new ] raise: Break.
	self should: [ obj2 instVarReads] raise: Break.
	self should: [ obj2 instVarWrites] raise: Break
	
	
]

{ #category : #'tests - object-centric' }
FieldWatchpointTest >> testWatchVariableInObject [
	wp := FieldWatchpoint watchVariable: #v1 inObject: obj1.
	self assert: wp targetInstance equals: obj1.	
	
	self should: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.	
		
	self shouldnt: [FieldWatchpointMockClass new] raise: Break.
	self shouldnt: [obj3 v1] raise: Break.
	self shouldnt: [obj3 v1: 0] raise: Break
	
	
]

{ #category : #'tests - class wide watchpoints' }
FieldWatchpointTest >> testWatchVariableReadsIn [ 	

	wp := FieldWatchpoint watchVariableReads: #v1 in: FieldWatchpointMockClass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1).
	self assert: wp targetClass identicalTo: FieldWatchpointMockClass.
	self assert: wp targetInstance equals: nil.

	self assertCollection: wp link nodes asIdentitySet 
			equals: (self allNodesForV1 select:[:n| n isVariable]) asIdentitySet.
	
	self shouldnt: [FieldWatchpointMockClass new] raise: Break.
	self should: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	self shouldnt: [ FieldWatchpointMockSubclass new ] raise: Break.
	self should: [ obj2 instVarReads] raise: Break.
	self shouldnt: [ obj2 instVarWrites] raise: Break
	
	
]

{ #category : #'tests - object-centric' }
FieldWatchpointTest >> testWatchVariableReadsInObject [ 	

	wp := FieldWatchpoint watchVariableReads: #v1 inObject: obj1.
	self assert: wp targetInstance equals: obj1.
	self assert: wp accessStrategy equals: #read.
	
	self should: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	
	self shouldnt: [FieldWatchpointMockClass new] raise: Break.
	self shouldnt: [obj3 v1] raise: Break.
	self shouldnt: [obj3 v1: 0] raise: Break
	
	
]

{ #category : #'tests - class wide watchpoints' }
FieldWatchpointTest >> testWatchVariableWritesIn [ 	

	wp := FieldWatchpoint watchVariableWrites: #v1 in: FieldWatchpointMockClass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1).
	self assert: wp targetClass identicalTo: FieldWatchpointMockClass.
	self assert: wp targetInstance equals: nil.

	self assertCollection: wp link nodes asIdentitySet 
			equals: (self allNodesForV1 select:[:n| n isAssignment]) asIdentitySet.
	
	self should: [FieldWatchpointMockClass new] raise: Break.
	self shouldnt: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.
	self should: [ FieldWatchpointMockSubclass new ] raise: Break.
	self shouldnt: [ obj2 instVarReads] raise: Break.
	self should: [ obj2 instVarWrites] raise: Break
	
	
	
	
]

{ #category : #'tests - object-centric' }
FieldWatchpointTest >> testWatchVariableWritesInObject [ 	

	wp := FieldWatchpoint watchVariableWrites: #v1 inObject: obj1.	
	self assert: wp targetInstance equals: obj1.
	self assert: wp accessStrategy equals: #write.
		
	self should: [obj1 v1: 0] raise: Break.
	self shouldnt: [obj1 v1] raise: Break.		
			
	self shouldnt: [FieldWatchpointMockClass new] raise: Break.
	self shouldnt: [obj3 v1] raise: Break.
	self shouldnt: [obj3 v1: 0] raise: Break
	
	
	
	
]

{ #category : #'tests - class wide watchpoints' }
FieldWatchpointTest >> testWatchVariablesIn [	

	wp := FieldWatchpoint watchVariablesIn: FieldWatchpointMockSubclass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClass identicalTo: FieldWatchpointMockSubclass.
	self assert: wp targetInstance equals: nil.

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

{ #category : #'tests - object-centric' }
FieldWatchpointTest >> testWatchVariablesInObject [	

	wp := FieldWatchpoint watchVariablesInObject: obj2.	
	self assert: wp targetInstance equals: obj2.	
	
	self should: [obj2 instVarReads] raise: Break.
	self should: [obj2 instVarWrites] raise: Break.
	self should: [obj2 v2] raise: Break.	
	self should: [obj2 v2: 0] raise: Break.
	self should: [obj2 v1] raise: Break.	
	self should: [obj2 v1: 0] raise: Break.
	
	self shouldnt: [obj4 instVarReads] raise: Break.
	self shouldnt: [obj4 instVarWrites] raise: Break.
	self shouldnt: [obj4 v2] raise: Break.	
	self shouldnt: [obj4 v2: 0] raise: Break.
	self shouldnt: [obj4 v1] raise: Break.	
	self shouldnt: [obj4 v1: 0] raise: Break.
	
	self shouldnt: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	self shouldnt: [FieldWatchpointMockClass new] raise: Break.
	self shouldnt: [FieldWatchpointMockSubclass new ] raise: Break.
	
]

{ #category : #'tests - class wide watchpoints' }
FieldWatchpointTest >> testWatchVariablesReadsIn [	

	wp := FieldWatchpoint watchVariablesReadsIn: FieldWatchpointMockSubclass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClass identicalTo: FieldWatchpointMockSubclass.
	self assert: wp targetInstance equals: nil.
	
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

{ #category : #'tests - object-centric' }
FieldWatchpointTest >> testWatchVariablesReadsInObject [	

	wp := FieldWatchpoint watchVariablesReadsInObject: obj2.
	self assert: wp targetInstance equals: obj2.
	self assert: wp accessStrategy equals: #read.	 
	
	self should: [obj2 v2] raise: Break.		
	self should: [obj2 instVarReads] raise: Break.
	self should: [obj2 v1] raise: Break.
	self shouldnt: [obj2 instVarWrites] raise: Break.
	self shouldnt: [obj2 v1: 0] raise: Break.
	self shouldnt: [obj2 v2: 0] raise: Break.
	
	
	self shouldnt: [obj4 instVarReads] raise: Break.
	self shouldnt: [obj4 instVarWrites] raise: Break.
	self shouldnt: [obj4 v2] raise: Break.	
	self shouldnt: [obj4 v2: 0] raise: Break.
	self shouldnt: [obj4 v1] raise: Break.	
	self shouldnt: [obj4 v1: 0] raise: Break.
	
	self shouldnt: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	self shouldnt: [FieldWatchpointMockClass new] raise: Break.
	self shouldnt: [FieldWatchpointMockSubclass new ] raise: Break.
	
]

{ #category : #'tests - class wide watchpoints' }
FieldWatchpointTest >> testWatchVariablesWritesIn [	

	wp := FieldWatchpoint watchVariablesWritesIn: FieldWatchpointMockSubclass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClass identicalTo: FieldWatchpointMockSubclass.
	self assert: wp targetInstance equals: nil.
	
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

{ #category : #'tests - object-centric' }
FieldWatchpointTest >> testWatchVariablesWritesInObject [	

	wp := FieldWatchpoint watchVariablesWritesInObject: obj2.
	self assert: wp targetInstance equals: obj2.
	self assert: wp accessStrategy equals: #write.	
	
	self should: [obj2 instVarWrites] raise: Break.
	self should: [obj2 v1: 0] raise: Break.
	self should: [obj2 v2: 0] raise: Break.
	self shouldnt: [obj2 v2] raise: Break.		
	self shouldnt: [obj2 instVarReads] raise: Break.
	self shouldnt: [obj2 v1] raise: Break.		
	
	self shouldnt: [obj4 instVarReads] raise: Break.
	self shouldnt: [obj4 instVarWrites] raise: Break.
	self shouldnt: [obj4 v2] raise: Break.	
	self shouldnt: [obj4 v2: 0] raise: Break.
	self shouldnt: [obj4 v1] raise: Break.	
	self shouldnt: [obj4 v1: 0] raise: Break.
	
	self shouldnt: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	self shouldnt: [FieldWatchpointMockClass new] raise: Break.
	self shouldnt: [FieldWatchpointMockSubclass new ] raise: Break.
	
]
