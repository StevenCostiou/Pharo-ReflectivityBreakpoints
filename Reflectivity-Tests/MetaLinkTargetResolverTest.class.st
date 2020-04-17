"
Note that for API with options the same methods are called for objects and classes, so the test is made only once.
"
Class {
	#name : #MetaLinkTargetResolverTest,
	#superclass : #TestCase,
	#category : #'Reflectivity-Tests'
}

{ #category : #tests }
MetaLinkTargetResolverTest >> testFindClassVariable [
	| classVar |
	classVar := ReflectivityExamples classVariableNamed: 'singleton'.
	self assert: (MetalinkTargetResolver classVariableNamed: 'singleton' for: ReflectivityExamples) identicalTo: classVar.
	self assert: (MetalinkTargetResolver classVariableNamed: 'singleton' for: ReflectivityExamples new) identicalTo: classVar
]

{ #category : #tests }
MetaLinkTargetResolverTest >> testFindClassVariableWithOptions [
	| classVar readNodes writeNodes |
	classVar := ReflectivityExamples classVariableNamed: 'singleton'.
	readNodes := classVar readNodes asIdentitySet.
	writeNodes := classVar assignmentNodes asIdentitySet.
	self assert: (MetalinkTargetResolver classVariableNamed: 'singleton' for: ReflectivityExamples option: #read) equals: readNodes.
	self assert: (MetalinkTargetResolver classVariableNamed: 'singleton' for: ReflectivityExamples option: #write) equals: writeNodes.
	self
		assert: (MetalinkTargetResolver classVariableNamed: 'singleton' for: ReflectivityExamples option: #all)
		equals: (Array with: writeNodes with: readNodes) flattened asIdentitySet
]

{ #category : #tests }
MetaLinkTargetResolverTest >> testFindMethod [
	| ast |
	ast := (ReflectivityExamples >> #exampleMethod) ast.
	self assert: (MetalinkTargetResolver methodNamed: #exampleMethod for: ReflectivityExamples) identicalTo: ast.
	self assert: (MetalinkTargetResolver methodNamed: #exampleMethod for: ReflectivityExamples new) identicalTo: ast
]

{ #category : #tests }
MetaLinkTargetResolverTest >> testFindSlot [
	| slot |
	slot := ReflectivityExamples slotNamed: 'tag'.
	self assert: (MetalinkTargetResolver slotNamed: 'tag' for: ReflectivityExamples) identicalTo: slot.
	self assert: (MetalinkTargetResolver slotNamed: 'tag' for: ReflectivityExamples new) identicalTo: slot
]

{ #category : #tests }
MetaLinkTargetResolverTest >> testFindSlotWithOptions [
	| slot readNodes writeNodes |
	slot := ReflectivityExamples slotNamed: 'tag'.
	readNodes := slot readNodes asIdentitySet.
	writeNodes := slot assignmentNodes asIdentitySet.
	self assert: (MetalinkTargetResolver slotNamed: 'tag' for: ReflectivityExamples option: #read) equals: readNodes.
	self assert: (MetalinkTargetResolver slotNamed: 'tag' for: ReflectivityExamples option: #write) equals: writeNodes.
	self
		assert: (MetalinkTargetResolver slotNamed: 'tag' for: ReflectivityExamples option: #all)
		equals: (Array with: writeNodes with: readNodes) flattened asIdentitySet
]

{ #category : #tests }
MetaLinkTargetResolverTest >> testFindTemporaryVariable [
	| temp |
	temp := ReflectivityExamples >> #exampleIfTrueIfFalse temporaryVariableNamed: #t.
	self assert: (MetalinkTargetResolver temporaryNamed: #t inMethod: #exampleIfTrueIfFalse for: ReflectivityExamples) equals: temp.
	self assert: (MetalinkTargetResolver temporaryNamed: #t inMethod: #exampleIfTrueIfFalse for: ReflectivityExamples new) equals: temp
]

{ #category : #tests }
MetaLinkTargetResolverTest >> testFindTemporaryVariableWithOptions [
	| temp readNodes writeNodes |
	temp := ReflectivityExamples >> #exampleIfTrueIfFalse temporaryVariableNamed: #t.
	readNodes := temp readNodes asIdentitySet.
	writeNodes := temp assignmentNodes asIdentitySet.
	self
		assert:
			(MetalinkTargetResolver
				temporaryNamed: #t
				inMethod: #exampleIfTrueIfFalse
				for: ReflectivityExamples
				option: #read)
		equals: readNodes.
	self
		assert:
			(MetalinkTargetResolver
				temporaryNamed: #t
				inMethod: #exampleIfTrueIfFalse
				for: ReflectivityExamples
				option: #write)
		equals: writeNodes.
	self
		assert:
			(MetalinkTargetResolver
				temporaryNamed: #t
				inMethod: #exampleIfTrueIfFalse
				for: ReflectivityExamples
				option: #all)
		equals: (Array with: writeNodes with: readNodes) flattened asIdentitySet
]

{ #category : #tests }
MetaLinkTargetResolverTest >> testRecoverClassFromEntity [
	self assert: (MetalinkTargetResolver classFor: ReflectivityExamples new) identicalTo: ReflectivityExamples.
	self assert: (MetalinkTargetResolver classFor: ReflectivityExamples) identicalTo: ReflectivityExamples
]

{ #category : #tests }
MetaLinkTargetResolverTest >> testUsingNodesForVariablesIn [
	| slot astNodes resolvedNodes |
	slot := ReflectivityExamples2 slotNamed: 'instVar'.

	"We get all variable nodes refering to the slot in the RFExample2 class hierarchy"
	astNodes := (ReflectivityExamples2 withAllSubclasses
		flatCollect: [ :c | c variableNodes ])
		select: [ :each | each binding variable == slot ].

	"We use the target resolver to find all nodes for our slot"
	resolvedNodes := MetalinkTargetResolver
		usingNodesForVariable: slot
		in:
			{ReflectivityExamples2Subclass.
			ReflectivityExamples2}.

	"First we test that each collected node is a variable node with a binding to our slot"
	resolvedNodes
		do: [ :node | 
			self assert: node isVariable.
			self assert: node binding variable identicalTo: slot ].
	
	"Then we check that both nodes collections contains the exact same nodes"	
	self assertCollection: resolvedNodes asIdentitySet equals: astNodes asIdentitySet
]
