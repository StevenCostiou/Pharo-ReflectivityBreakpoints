Class {
	#name : #VariableBreakpointTest,
	#superclass : #TestCase,
	#instVars : [
		'obj1',
		'obj2',
		'wp',
		'obj3',
		'obj4',
		'observer'
	],
	#category : #'Reflectivity-Field-Watchpoints'
}

{ #category : #helpers }
VariableBreakpointTest >> allNodes [
	^ OrderedCollection new
		addAll: self allNodesForV1;
		addAll: self allNodesForV2;
		yourself
]

{ #category : #helpers }
VariableBreakpointTest >> allNodesForV1 [
	^ OrderedCollection new
		addAll: self nodesForV1InFieldWatchpointMockClass;
		addAll: self nodesForV1InFieldWatchpointMockSubclass;
		yourself
]

{ #category : #helpers }
VariableBreakpointTest >> allNodesForV2 [
	^ OrderedCollection new
		addAll: self nodesForV2InFieldWatchpointMockSubclass;
		yourself
]

{ #category : #helpers }
VariableBreakpointTest >> allTempNodes [
	^ OrderedCollection new
		addAll: self tempReadNodes;
		addAll: self tempWriteNodes;
		yourself
]

{ #category : #helpers }
VariableBreakpointTest >> argNodes [
	|nodes |
	nodes := OrderedCollection new.
	nodes add: (VariableBreakpointMockClass>>#methodWithTempsAndArg:) ast statements first value.
	^nodes
]

{ #category : #helpers }
VariableBreakpointTest >> nodesForV1InFieldWatchpointMockClass [
	|nodes |
	nodes := OrderedCollection new.
	nodes add: (VariableBreakpointMockClass>>#initialize) ast statements first.
	nodes add: (VariableBreakpointMockClass>>#v1) ast statements first value.
	nodes add: (VariableBreakpointMockClass>>#v1:) ast statements first.
	^nodes
]

{ #category : #helpers }
VariableBreakpointTest >> nodesForV1InFieldWatchpointMockSubclass [
	|nodes |
	nodes := OrderedCollection new.
	nodes add: (VariableBreakpointMockSubclass>>#instVarWrites) ast statements first.
	nodes add: (VariableBreakpointMockSubclass>>#instVarReads) ast statements first value receiver.
	^nodes
]

{ #category : #helpers }
VariableBreakpointTest >> nodesForV2InFieldWatchpointMockSubclass [
	|nodes |
	nodes := OrderedCollection new.
	nodes add: (VariableBreakpointMockSubclass>>#initialize) ast statements second.
	nodes add: (VariableBreakpointMockSubclass>>#instVarReads) ast statements first value arguments first.
	nodes add: (VariableBreakpointMockSubclass>>#instVarWrites) ast statements second.
	nodes add: (VariableBreakpointMockSubclass>>#v2) ast statements first value.
	nodes add: (VariableBreakpointMockSubclass>>#v2:) ast statements first.
	^nodes
]

{ #category : #running }
VariableBreakpointTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	obj1 := VariableBreakpointMockClass new.
	obj2 := VariableBreakpointMockSubclass new.
	obj3 := VariableBreakpointMockClass new.
	obj4 := VariableBreakpointMockSubclass new.
	observer := DummyBreakpointObserver new.
	Breakpoint registerObserver: observer
]

{ #category : #running }
VariableBreakpointTest >> tearDown [
	wp
		ifNotNil: [ wp isInstalled
				ifTrue: [ wp remove ] ].
	Breakpoint unregisterObserver: observer.
	super tearDown
]

{ #category : #helpers }
VariableBreakpointTest >> tempReadNodes [
	|nodes |
	nodes := OrderedCollection new.
	nodes add: (VariableBreakpointMockClass>>#methodWithTempsAndArg:) ast statements last value.
	^nodes
]

{ #category : #helpers }
VariableBreakpointTest >> tempWriteNodes [
	|nodes |
	nodes := OrderedCollection new.
	nodes add: (VariableBreakpointMockClass>>#methodWithTempsAndArg:) ast statements first.
	^nodes
]

{ #category : #'tests - installation' }
VariableBreakpointTest >> testAccessStrategy [
	
	wp := VariableBreakpoint watchVariablesIn: VariableBreakpointMockClass.
	self assert: wp accessStrategy equals: #all.
	wp remove.
	
	wp := VariableBreakpoint watchVariable: #v1 in: VariableBreakpointMockClass.
	self assert: wp accessStrategy equals: #all.
	wp remove.
	
	wp := VariableBreakpoint watchVariable: #v1 inObject: obj1.
	self assert: wp accessStrategy equals: #all.
	wp remove.
	
	wp := VariableBreakpoint watchVariablesInObject: obj1.	
	self assert: wp accessStrategy equals: #all.
	wp remove.
		
	wp := VariableBreakpoint watchVariableWrites: #v1 in: VariableBreakpointMockClass.
	self assert: wp accessStrategy equals: #write.
	wp remove.
	
	wp := VariableBreakpoint watchVariablesWritesIn: VariableBreakpointMockClass.
	self assert: wp accessStrategy equals: #write.
	wp remove.
	
	wp := VariableBreakpoint watchVariablesWritesIn: VariableBreakpointMockSubclass.
	self assert: wp accessStrategy equals: #write.
	wp remove.
	
	wp := VariableBreakpoint watchVariableWrites: #v1 inObject: obj1.
	self assert: wp accessStrategy equals: #write.
	wp remove.
	
	wp := VariableBreakpoint watchVariablesReadsInObject: obj1.
	self assert: wp accessStrategy equals: #read.
	wp remove.
	
	wp := VariableBreakpoint watchVariableReads: #v1 in: VariableBreakpointMockClass.
	self assert: wp accessStrategy equals: #read.
	wp remove.
	
	wp := VariableBreakpoint watchVariableReads: #v1 inObject: obj1.
	self assert: wp accessStrategy equals: #read.
	wp remove.
	
	wp := VariableBreakpoint watchVariablesReadsInObject: obj1.
	self assert: wp accessStrategy equals: #read.
	wp remove.
	
]

{ #category : #'tests - initialization' }
VariableBreakpointTest >> testAllSlotNamesFor [
	self
		assertCollection: (VariableBreakpoint allSlotNamesFor: VariableBreakpointMockSubclass)
		equals: (OrderedCollection with: #v1 with: #v2)
]

{ #category : #'tests - temp var breakpoints' }
VariableBreakpointTest >> testBreakpointOnAllTempAccesses [
	|method|
	method := (VariableBreakpointMockClass>> #methodWithTempsAndArg:).
	wp := VariableBreakpoint watchVariable: #temp in: method.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #temp).
	self assert: wp targetClassOrMethod identicalTo: method.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: wp link nodes asIdentitySet equals: self allTempNodes asIdentitySet.	
	self should: [obj1 methodWithTempsAndArg: 42] raise: Break	
	
]

{ #category : #'tests - temp var breakpoints' }
VariableBreakpointTest >> testBreakpointOnArgument [
	|method|
	method := (VariableBreakpointMockClass>> #methodWithTempsAndArg:).
	wp := VariableBreakpoint watchVariable: #arg in: method.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #arg).
	self assert: wp targetClassOrMethod identicalTo: method.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: wp link nodes asIdentitySet equals: self argNodes asIdentitySet.	
	self should: [obj1 methodWithTempsAndArg: 42] raise: Break	
	
]

{ #category : #'tests - temp var breakpoints' }
VariableBreakpointTest >> testBreakpointOnTempReads [
	|method|
	method := (VariableBreakpointMockClass>> #methodWithTempsAndArg:).
	wp := VariableBreakpoint watchVariableReads: #temp in: method.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #temp).
	self assert: wp targetClassOrMethod identicalTo: method.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: wp link nodes asIdentitySet equals: self tempReadNodes asIdentitySet.	
	self should: [obj1 methodWithTempsAndArg: 42] raise: Break	
	
]

{ #category : #'tests - temp var breakpoints' }
VariableBreakpointTest >> testBreakpointOnTempWrites [
	|method|
	method := (VariableBreakpointMockClass>> #methodWithTempsAndArg:).
	wp := VariableBreakpoint watchVariableWrites: #temp in: method.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #temp).
	self assert: wp targetClassOrMethod identicalTo: method.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: wp link nodes asIdentitySet equals: self tempWriteNodes asIdentitySet.	
	self should: [obj1 methodWithTempsAndArg: 42] raise: Break	
	
]

{ #category : #'tests - initialization' }
VariableBreakpointTest >> testInitialize [ 	
	wp := VariableBreakpoint new.
	self assert: wp accessStrategy equals: #all.
	self assertEmpty: wp targetVariableNames.
	self deny: wp isInstalled
]

{ #category : #'tests - installation' }
VariableBreakpointTest >> testInstall [
	
	wp := VariableBreakpoint newWatchPointInClass: VariableBreakpointMockSubclass.	
	wp install.
	self assertCollection: Breakpoint all includesAll: (OrderedCollection with: wp)
]

{ #category : #'tests - installation' }
VariableBreakpointTest >> testIsInstalled [
	
	wp := VariableBreakpoint newWatchPointInClass: VariableBreakpointMockSubclass.
	self deny: wp isInstalled.
	wp install.
	self assert: wp isInstalled
]

{ #category : #'tests - initialization' }
VariableBreakpointTest >> testIsWatchpoint [
	self assert: VariableBreakpoint new isWatchpoint.
	self deny: Breakpoint new isWatchpoint
]

{ #category : #'tests - initialization' }
VariableBreakpointTest >> testNewBreakpointForVariableInClass [
	wp := VariableBreakpoint newBreakpointForVariable: #var inClass: #class.
	self assert: wp class identicalTo: VariableBreakpoint.
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #var).
	self assert: wp targetClassOrMethod equals: #class
]

{ #category : #'tests - initialization' }
VariableBreakpointTest >> testNewBreakpointForVariableInClassForMethod [
]

{ #category : #'tests - initialization' }
VariableBreakpointTest >> testNewWatchPointInClass [
	wp := VariableBreakpoint newWatchPointInClass: VariableBreakpointMockSubclass.
	self assert: wp class identicalTo: VariableBreakpoint.
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClassOrMethod equals: VariableBreakpointMockSubclass
]

{ #category : #'tests - notifications' }
VariableBreakpointTest >> testNotifyArgumentBreakpointHit [
	|method notification|
	method := (VariableBreakpointMockClass>> #methodWithTempsAndArg:).
	wp := VariableBreakpoint watchVariable: #arg in: method.
	self should: [obj1 methodWithTempsAndArg: 42] raise: Break.
	notification := observer tag.
	self assert: notification breakpoint identicalTo: wp.
	self assert: notification nodes size equals: 1.
	self assert: notification nodes first equals: method ast statements first value.
	self assert: notification valueOrNil equals: 42
]

{ #category : #'tests - notifications' }
VariableBreakpointTest >> testNotifyInstVarBreakpointHit [
	|method notification|
	obj1 v1: 0.
	method := (VariableBreakpointMockClass>> #v1).
	wp := VariableBreakpoint watchVariableReads: #v1 in: VariableBreakpointMockClass.
	self should: [obj1 v1] raise: Break.
	
	notification := observer tag.
	self assert: notification breakpoint identicalTo: wp.
	self assert: notification nodes size equals: 1.
	self assert: notification nodes first equals: method ast statements first value.
	self assert: notification valueOrNil equals: 0.
	
	wp remove.
	observer update: nil.
	method := (VariableBreakpointMockClass>> #v1:).
	wp := VariableBreakpoint watchVariableWrites: #v1 in: VariableBreakpointMockClass.	
	self should: [obj1 v1: 42] raise: Break.
	
	notification := observer tag.
	self assert: notification breakpoint identicalTo: wp.
	self assert: notification nodes size equals: 1.
	self assert: notification nodes first equals: method ast statements first.
	self assert: notification valueOrNil equals: 42.
]

{ #category : #'tests - notifications' }
VariableBreakpointTest >> testNotifyTempBreakpointHit [
	|method notification|
	method := (VariableBreakpointMockClass>> #methodWithTempsAndArg:).
	wp := VariableBreakpoint watchVariableReads: #temp in: method.
	self should: [obj1 methodWithTempsAndArg: 42] raise: Break.
	
	notification := observer tag.
	self assert: notification breakpoint identicalTo: wp.
	self assert: notification nodes size equals: 1.
	self assert: notification nodes first equals: method ast statements last value.
	self assert: notification valueOrNil equals: 42.
	
	wp remove.
	observer update: nil.
	wp := VariableBreakpoint watchVariableWrites: #temp in: method.
	self should: [obj1 methodWithTempsAndArg: 42] raise: Break.
	
	notification := observer tag.
	self assert: notification breakpoint identicalTo: wp.
	self assert: notification nodes size equals: 1.
	self assert: notification nodes first equals: method ast statements first.
	self assert: notification valueOrNil equals: 42
]

{ #category : #'tests - installation' }
VariableBreakpointTest >> testRemove [

	wp := VariableBreakpoint watchVariablesIn: VariableBreakpointMockSubclass.
	wp remove.
	
	self denyCollection: Breakpoint all includesAll: (OrderedCollection with: wp).	
	self assertEmpty: wp link nodes.
	self assertEmpty: (self allNodes asIdentitySet flatCollect:[:n| n links]).
	
	self shouldnt: [VariableBreakpointMockClass new] raise: Break.
	self shouldnt: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	self shouldnt: [VariableBreakpointMockSubclass new ] raise: Break.
	self shouldnt: [obj2 instVarReads] raise: Break.
	self shouldnt: [obj2 instVarWrites] raise: Break.
	self shouldnt: [obj2 v2] raise: Break.	
	self shouldnt: [obj2 v2: 0] raise: Break.
	self shouldnt: [obj2 v1] raise: Break.	
	self shouldnt: [obj2 v1: 0] raise: Break.
	
]

{ #category : #'tests - installation' }
VariableBreakpointTest >> testScopeTo [
	| instance testContext |
	instance := Object new.
	testContext := Context newForMethod: VariableBreakpointMockClass >> #v1.
	wp := VariableBreakpoint new.
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
VariableBreakpointTest >> testWatchVariableIn [ 	

	wp := VariableBreakpoint watchVariable: #v1 in: VariableBreakpointMockClass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1).
	self assert: wp targetClassOrMethod identicalTo: VariableBreakpointMockClass.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: wp link nodes asIdentitySet equals: self allNodesForV1 asIdentitySet.
	
	self should: [VariableBreakpointMockClass new] raise: Break.
	self should: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.
	self should: [ VariableBreakpointMockSubclass new ] raise: Break.
	self should: [ obj2 instVarReads] raise: Break.
	self should: [ obj2 instVarWrites] raise: Break
	
	
]

{ #category : #'tests - object-centric' }
VariableBreakpointTest >> testWatchVariableInObject [
	wp := VariableBreakpoint watchVariable: #v1 inObject: obj1.
	self assert: wp targetInstance equals: obj1.	
	
	self should: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.	
		
	self shouldnt: [VariableBreakpointMockClass new] raise: Break.
	self shouldnt: [obj3 v1] raise: Break.
	self shouldnt: [obj3 v1: 0] raise: Break
	
	
]

{ #category : #'tests - class wide watchpoints' }
VariableBreakpointTest >> testWatchVariableReadsIn [ 	

	wp := VariableBreakpoint watchVariableReads: #v1 in: VariableBreakpointMockClass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1).
	self assert: wp targetClassOrMethod identicalTo: VariableBreakpointMockClass.
	self assert: wp targetInstance equals: nil.

	self assertCollection: wp link nodes asIdentitySet 
			equals: (self allNodesForV1 select:[:n| n isVariable]) asIdentitySet.
	
	self shouldnt: [VariableBreakpointMockClass new] raise: Break.
	self should: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	self shouldnt: [ VariableBreakpointMockSubclass new ] raise: Break.
	self should: [ obj2 instVarReads] raise: Break.
	self shouldnt: [ obj2 instVarWrites] raise: Break
	
	
]

{ #category : #'tests - object-centric' }
VariableBreakpointTest >> testWatchVariableReadsInObject [ 	

	wp := VariableBreakpoint watchVariableReads: #v1 inObject: obj1.
	self assert: wp targetInstance equals: obj1.
	self assert: wp accessStrategy equals: #read.
	
	self should: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	
	self shouldnt: [VariableBreakpointMockClass new] raise: Break.
	self shouldnt: [obj3 v1] raise: Break.
	self shouldnt: [obj3 v1: 0] raise: Break
	
	
]

{ #category : #'tests - class wide watchpoints' }
VariableBreakpointTest >> testWatchVariableWritesIn [ 	

	wp := VariableBreakpoint watchVariableWrites: #v1 in: VariableBreakpointMockClass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1).
	self assert: wp targetClassOrMethod identicalTo: VariableBreakpointMockClass.
	self assert: wp targetInstance equals: nil.

	self assertCollection: wp link nodes asIdentitySet 
			equals: (self allNodesForV1 select:[:n| n isAssignment]) asIdentitySet.
	
	self should: [VariableBreakpointMockClass new] raise: Break.
	self shouldnt: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.
	self should: [ VariableBreakpointMockSubclass new ] raise: Break.
	self shouldnt: [ obj2 instVarReads] raise: Break.
	self should: [ obj2 instVarWrites] raise: Break
	
	
	
	
]

{ #category : #'tests - object-centric' }
VariableBreakpointTest >> testWatchVariableWritesInObject [ 	

	wp := VariableBreakpoint watchVariableWrites: #v1 inObject: obj1.	
	self assert: wp targetInstance equals: obj1.
	self assert: wp accessStrategy equals: #write.
		
	self should: [obj1 v1: 0] raise: Break.
	self shouldnt: [obj1 v1] raise: Break.		
			
	self shouldnt: [VariableBreakpointMockClass new] raise: Break.
	self shouldnt: [obj3 v1] raise: Break.
	self shouldnt: [obj3 v1: 0] raise: Break
	
	
	
	
]

{ #category : #'tests - class wide watchpoints' }
VariableBreakpointTest >> testWatchVariablesIn [	

	wp := VariableBreakpoint watchVariablesIn: VariableBreakpointMockSubclass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClassOrMethod identicalTo: VariableBreakpointMockSubclass.
	self assert: wp targetInstance equals: nil.

	self assertCollection: wp link nodes asIdentitySet equals: self allNodes asIdentitySet.
	
	self should: [VariableBreakpointMockClass new] raise: Break.
	self should: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.
	self should: [VariableBreakpointMockSubclass new ] raise: Break.
	self should: [obj2 instVarReads] raise: Break.
	self should: [obj2 instVarWrites] raise: Break.
	self should: [obj2 v2] raise: Break.	
	self should: [obj2 v2: 0] raise: Break.
	self should: [obj2 v1] raise: Break.	
	self should: [obj2 v1: 0] raise: Break.
	
]

{ #category : #'tests - object-centric' }
VariableBreakpointTest >> testWatchVariablesInObject [	

	wp := VariableBreakpoint watchVariablesInObject: obj2.	
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
	self shouldnt: [VariableBreakpointMockClass new] raise: Break.
	self shouldnt: [VariableBreakpointMockSubclass new ] raise: Break.
	
]

{ #category : #'tests - class wide watchpoints' }
VariableBreakpointTest >> testWatchVariablesReadsIn [	

	wp := VariableBreakpoint watchVariablesReadsIn: VariableBreakpointMockSubclass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClassOrMethod identicalTo: VariableBreakpointMockSubclass.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: wp link nodes asIdentitySet 
			equals: (self allNodes select:[:n| n isVariable]) asIdentitySet.
	
	self shouldnt: [VariableBreakpointMockClass new] raise: Break.
	self should: [obj1 v1] raise: Break.	
	self shouldnt: [obj1 v1: 0] raise: Break.
	self shouldnt: [VariableBreakpointMockSubclass new ] raise: Break.
	self should: [obj2 instVarReads] raise: Break.
	self shouldnt: [obj2 instVarWrites] raise: Break.
	self should: [obj2 v2] raise: Break.	
	self shouldnt: [obj2 v2: 0] raise: Break.
	self should: [obj2 v1] raise: Break.	
	self shouldnt: [obj2 v1: 0] raise: Break.
	
]

{ #category : #'tests - object-centric' }
VariableBreakpointTest >> testWatchVariablesReadsInObject [	

	wp := VariableBreakpoint watchVariablesReadsInObject: obj2.
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
	self shouldnt: [VariableBreakpointMockClass new] raise: Break.
	self shouldnt: [VariableBreakpointMockSubclass new ] raise: Break.
	
]

{ #category : #'tests - class wide watchpoints' }
VariableBreakpointTest >> testWatchVariablesWritesIn [	

	wp := VariableBreakpoint watchVariablesWritesIn: VariableBreakpointMockSubclass.
	
	self assertCollection: wp targetVariableNames equals: (OrderedCollection with: #v1 with: #v2).
	self assert: wp targetClassOrMethod identicalTo: VariableBreakpointMockSubclass.
	self assert: wp targetInstance equals: nil.
	
	self assertCollection: wp link nodes asIdentitySet 
			equals: (self allNodes select:[:n| n isAssignment]) asIdentitySet.
	
	self should: [VariableBreakpointMockClass new] raise: Break.
	self shouldnt: [obj1 v1] raise: Break.	
	self should: [obj1 v1: 0] raise: Break.
	self should: [VariableBreakpointMockSubclass new ] raise: Break.
	self shouldnt: [obj2 instVarReads] raise: Break.
	self should: [obj2 instVarWrites] raise: Break.
	self shouldnt: [obj2 v2] raise: Break.	
	self should: [obj2 v2: 0] raise: Break.
	self shouldnt: [obj2 v1] raise: Break.	
	self should: [obj2 v1: 0] raise: Break.
	
]

{ #category : #'tests - object-centric' }
VariableBreakpointTest >> testWatchVariablesWritesInObject [	

	wp := VariableBreakpoint watchVariablesWritesInObject: obj2.
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
	self shouldnt: [VariableBreakpointMockClass new] raise: Break.
	self shouldnt: [VariableBreakpointMockSubclass new ] raise: Break.
	
]
